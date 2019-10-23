provider "aws" {
  region = var.cert_region
  alias  = "cert"
}

resource "aws_acm_certificate" "cert" {
  provider                  = aws.cert
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"
  tags                      = var.cert_tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  provider        = aws.cert
  name            = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type            = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  records         = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl             = var.cert_validation_record_ttl
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.cert
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
