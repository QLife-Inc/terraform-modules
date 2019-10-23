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
      tags    = lifecycle_rule.value.tags != null ? lifecycle_rule.value.tags : var.bucket_tags
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

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.sse_kms_master_key_id
      }
    }
  }
}
