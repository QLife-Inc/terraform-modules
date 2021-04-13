/* ==================================================
 * サイトファイルを格納する S3 バケット
 ================================================== */
resource "aws_s3_bucket" "site_bucket" {
  bucket        = var.bucket_name
  acl           = "private"
  tags          = var.bucket_tags
  force_destroy = var.force_destroy

  website {
    index_document = var.index_document
    error_document = var.error_document
    routing_rules  = local.routing_rules
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = var.cors_allowed_origins
    max_age_seconds = 3000
  }
}

locals {
  routing_rules = length(var.routing_rules) > 0 ? jsonencode([for rule in var.routing_rules : {
    Condition = rule.condition
    Redirect  = rule.redirect
  }]) : null
}
