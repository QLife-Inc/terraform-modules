module "site_bucket" {
  source        = "./site_bucket"
  aws_region    = var.site_bucket_region
  bucket_name   = var.site_bucket_name
  bucket_tags   = var.site_bucket_tags
  force_destroy = var.site_bucket_force_destroy
}

module "restrict_ips" {
  source               = "./restrict_ips"
  function_name        = var.restrict_ips_function_name
  function_tags        = var.restrict_ips_function_tags
  function_role_name   = var.restrict_ips_function_role_name
  function_role_tags   = local.restrict_ips_function_role_tags
  allowed_ip_addresses = var.allowed_ip_addresses
}

module "cloudfront_s3" {
  source                    = "./cloudfront_s3"
  origin_bucket_name        = module.site_bucket.s3_bucket.id
  distribution_enabled      = var.cf_distribution_enabled
  ipv6_enabled              = var.cf_ipv6_enabled
  distribution_comment      = var.cf_distribution_comment
  default_root_object       = var.cf_default_root_object
  logging_config            = var.cf_logging_config
  domain_names              = var.cf_domain_names
  s3_origin_id              = var.cf_s3_origin_id
  s3_origin_path            = var.cf_s3_origin_path
  distribution_tags         = var.cf_distribution_tags
  viewer_protocol_policy    = var.cf_viewer_protocol_policy
  compress                  = var.cf_compress
  min_ttl                   = var.cf_min_ttl
  default_ttl               = var.cf_default_ttl
  max_ttl                   = var.cf_max_ttl
  price_class               = var.cf_price_class
  not_found_caching_min_ttl = var.cf_not_found_caching_min_ttl
  not_found_page_path       = var.cf_not_found_page_path
  geo_restriction_type      = var.cf_geo_restriction_type
  geo_restriction_locations = var.cf_geo_restriction_locations
  acm_certificate_arn       = var.cf_acm_certificate_arn
  minimum_protocol_version  = var.cf_minimum_protocol_version
  hosted_zone_id            = var.cf_hosted_zone_id

  // IP 制限なし(allowed_ip_addressが空)の場合は module.restrict_ips.function が空のリストとなるため、
  // Lambda@Edge はアタッチされない。
  lambda_function_associations = [for func in module.restrict_ips.function : {
    event_type   = "viewer-request"
    lambda_arn   = func.qualified_arn
    include_body = true
  }]
}
