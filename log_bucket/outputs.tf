output "log_bucket" {
  value = var.enabled ? aws_s3_bucket.logs.* : []
}
