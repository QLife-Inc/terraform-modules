variable "bucket_name" {
  description = "ログ格納バケットのバケット名"
  default     = null
}

variable "enabled" {
  description = "ログ格納バケットを作成するかどうか"
  default     = true
}

variable "aws_region" {
  description = "ログ格納バケットのリージョン (デフォルト: ap-northeast-1)"
  default     = "ap-northeast-1"
}

variable "bucket_tags" {
  type        = map(string)
  description = "ログ格納バケットに設定するタグ"
  default     = {}
}

variable "force_destroy" {
  description = "ログ格納バケットが空じゃない場合に強制削除するかどうか (デフォルト: 強制削除する)"
  default     = true
}

variable "lifecycle_rules" {
  type = list(object({
    id          = string
    enabled     = bool
    prefix      = string
    filter_tags = map(string)
    transitions = list(object({
      storage_class = string
      days          = number
    }))
    expiration_days = number
  }))
  description = "ログ格納バケットに適用するライフサイクルルールのリスト"
  default = [{
    id          = "ALL"
    enabled     = true
    prefix      = ""
    filter_tags = null
    transitions = [{
      storage_class = "STANDARD_IA"
      days          = 30
    }]
    expiration_days = 365 * 5
  }]
}

variable "sse_algorithm" {
  description = "Server Side Encryption を有効にする場合に利用するアルゴリズム"
  default     = null
}

variable "sse_kms_master_key_id" {
  description = "Server Side Encryption を有効にする場合に利用する KMS マスターキーの ID"
  default     = null
}

locals {
  sse_settings = var.sse_kms_master_key_id != null ? [{
    kms_master_key_id = var.sse_kms_master_key_id
    sse_algorithm     = coalesce(var.sse_algorithm, "aws:kms")
  }] : []
}
