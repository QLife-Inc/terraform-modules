/* ==================================================
 * ログファイルを格納する S3 バケット
 ================================================== */
resource "aws_s3_bucket" "logs" {
  count         = var.enabled ? 1 : 0
  bucket        = var.bucket_name
  acl           = "log-delivery-write"
  region        = var.aws_region
  tags          = var.bucket_tags
  force_destroy = var.force_destroy

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id      = lifecycle_rule.value.id
      enabled = lifecycle_rule.value.enabled
      prefix  = lifecycle_rule.value.prefix
      tags    = lifecycle_rule.value.filter_tags
      transition {
        days          = lifecycle_rule.value.standard_transition_days
        storage_class = "STANDARD_IA"
      }
      transition {
        days          = lifecycle_rule.value.glacier_transition_days
        storage_class = "GLACIER"
      }
      expiration {
        days = lifecycle_rule.value.expiration_days
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = local.sse_settings
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm     = server_side_encryption_configuration.value.sse_algorithm
          kms_master_key_id = server_side_encryption_configuration.value.kms_master_key_id
        }
      }
    }
  }
}
