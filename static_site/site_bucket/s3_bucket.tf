/* ==================================================
 * サイトファイルを格納する S3 バケット
 ================================================== */
resource "aws_s3_bucket" "site_bucket" {
  bucket        = var.bucket_name
  acl           = "private"
  region        = var.aws_region
  tags          = var.bucket_tags
  force_destroy = var.force_destroy

  website {
    index_document = var.index_document
    error_document = var.error_document
    routing_rules = jsonencode([for rule in var.routing_rules : {
      Condition = rule.condition
      Redirect  = rule.redirect
    }])
  }
}
