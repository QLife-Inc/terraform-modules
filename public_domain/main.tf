module "domain" {
  source              = "./hosted_zone"
  domain_name         = var.domain_name
  hosted_zone_comment = var.hosted_zone_comment
  hosted_zone_tags    = var.hosted_zone_tags
  force_destroy       = var.zone_force_destroy
}

module "certificate" {
  source                     = "./cert"
  cert_region                = var.cert_region
  domain_name                = module.domain.route53_zone.name
  subject_alternative_names  = var.cert_subject_alternative_names
  cert_tags                  = var.cert_tags
  cert_validation_record_ttl = var.cert_validation_record_ttl
}
