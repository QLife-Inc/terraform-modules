output "site_bucket" {
  value = module.site_bucket.s3_bucket
}

output "cloudfront" {
  value = module.cloudfront_s3.s3_distribution
}
