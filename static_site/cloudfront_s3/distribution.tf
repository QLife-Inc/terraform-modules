data "aws_s3_bucket" "origin" {
  bucket = var.origin_bucket_name
}

locals {
  s3_origin_id   = coalesce(var.s3_origin_id, var.origin_bucket_name)
  empty_array    = []
  logging_config = var.logging_config == null ? local.empty_array : list(var.logging_config)
}

// Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = var.distribution_comment
}

// CloudFront ディストリビューション
resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = var.distribution_enabled
  is_ipv6_enabled     = var.ipv6_enabled
  comment             = var.distribution_comment
  default_root_object = var.default_root_object
  aliases             = var.domain_names
  price_class         = var.price_class
  tags                = var.distribution_tags

  origin {
    origin_id   = local.s3_origin_id
    domain_name = data.aws_s3_bucket.origin.bucket_regional_domain_name
    origin_path = var.s3_origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  // 静的サイトのみを想定しているため参照のみとし、QueryString も Cookie もオリジンに送信しない
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    compress         = var.compress

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl

    // 適用する Lambda@Edge
    dynamic "lambda_function_association" {
      for_each = var.lambda_function_associations
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }
  }

  // 静的サイトなので 404 以外発生せず、ページが必ず存在するものとする
  custom_error_response {
    error_caching_min_ttl = var.not_found_caching_min_ttl
    error_code            = 404
    response_code         = 404
    response_page_path    = var.not_found_page_path
  }

  // 配信地域制限
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  // SSL 証明書 (ACM の利用を想定, IAM のサーバー証明書はサポートしない)
  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.acm_certificate_arn == ""
    minimum_protocol_version       = var.acm_certificate_arn == "" ? "TLSv1" : var.minimum_protocol_version
    ssl_support_method             = "sni-only" # vipは非常に高額なため使わない
  }

  // アクセスログバケットが指定されていたらログを出力
  // 出力するバケットには CloudFront からのログ出力が許可されている必要がある
  // https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  dynamic "logging_config" {
    for_each = local.logging_config
    content {
      bucket          = logging_config.value.bucket
      prefix          = logging_config.value.prefix
      include_cookies = logging_config.value.include_cookies
    }
  }
}

resource "aws_route53_record" "alias_a" {
  count   = length(var.domain_names)
  zone_id = var.hosted_zone_id
  name    = var.domain_names[count.index]
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alias_aaaa" {
  count   = var.ipv6_enabled ? length(var.domain_names) : 0
  zone_id = var.hosted_zone_id
  name    = var.domain_names[count.index]
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
