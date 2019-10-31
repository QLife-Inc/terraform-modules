module "site_bucket" {
  source               = "./site_bucket"
  aws_region           = var.site_bucket_region
  bucket_name          = var.site_bucket_name
  bucket_tags          = var.site_bucket_tags
  cors_allowed_origins = var.site_bucket_origins
  force_destroy        = var.site_bucket_force_destroy
}

module "edge_function_role" {
  source    = "./edge_functions/role"
  role_name = var.edge_function_role_name
  role_tags = var.edge_function_role_tags
}

module "directory_index" {
  source            = "./edge_functions/directory_index"
  function_name     = var.directory_index_function_name
  function_tags     = var.directory_index_function_tags
  function_role_arn = module.edge_function_role.role.arn
}

module "restrict_ips" {
  source               = "./edge_functions/restrict_ips"
  function_name        = var.restrict_ips_function_name
  function_tags        = var.restrict_ips_function_tags
  function_role_arn    = module.edge_function_role.role.arn
  allowed_ip_addresses = var.allowed_ip_addresses
}

locals {
  directory_index_association = {
    event_type   = "origin-request"
    lambda_arn   = module.directory_index.function.qualified_arn
    include_body = true
  }
  // IP 制限なし(allowed_ip_addressが空)の場合は module.restrict_ips.function が
  // 空のリストとなるため、CloudFront にはアタッチされない。
  restrict_ips_association = [for func in module.restrict_ips.function : {
    event_type   = "viewer-request"
    lambda_arn   = func.qualified_arn
    include_body = true
  }]
}

module "cloudfront_s3" {
  source                       = "./cloudfront_s3"
  origin_bucket_name           = module.site_bucket.s3_bucket.id
  distribution_enabled         = var.cf_distribution_enabled
  ipv6_enabled                 = var.cf_ipv6_enabled
  distribution_comment         = var.cf_distribution_comment
  default_root_object          = var.cf_default_root_object
  logging_config               = var.cf_logging_config
  domain_names                 = var.cf_domain_names
  s3_origin_id                 = var.cf_s3_origin_id
  s3_origin_path               = var.cf_s3_origin_path
  distribution_tags            = var.cf_distribution_tags
  viewer_protocol_policy       = var.cf_viewer_protocol_policy
  compress                     = var.cf_compress
  min_ttl                      = var.cf_min_ttl
  default_ttl                  = var.cf_default_ttl
  max_ttl                      = var.cf_max_ttl
  price_class                  = var.cf_price_class
  not_found_caching_min_ttl    = var.cf_not_found_caching_min_ttl
  not_found_page_path          = var.cf_not_found_page_path
  geo_restriction_type         = var.cf_geo_restriction_type
  geo_restriction_locations    = var.cf_geo_restriction_locations
  acm_certificate_arn          = var.cf_acm_certificate_arn
  minimum_protocol_version     = var.cf_minimum_protocol_version
  hosted_zone_id               = var.cf_hosted_zone_id
  lambda_function_associations = concat([local.directory_index_association], local.restrict_ips_association)
}
