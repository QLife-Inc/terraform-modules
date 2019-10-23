output "hosted_zone" {
  value = module.domain.route53_zone
}

output "certificate" {
  value = module.certificate.acm_certificate
}
