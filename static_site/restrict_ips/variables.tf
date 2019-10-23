variable "function_name" {
  description = "Lambda@Edge 関数の名前"
  default     = "restrict-ips-on-viewer-request"
}

variable "function_tags" {
  type        = map(string)
  description = "Lambda@Edge 関数に設定する タグ"
  default     = {}
}

variable "function_role_name" {
  description = "Lambda@Edge 関数に設定する IAM ロール名"
  default     = "restrict-ips-function-role"
}

variable "function_role_tags" {
  type        = map(string)
  description = "Lambda@Edge 関数に設定する IAM ロールのタグ"
  default     = null
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "CloudFront 経由でのアクセスを許可する IP アドレスのリスト"
  default     = []
}

locals {
  function_role_tags = var.function_role_tags != null ? var.function_role_tags : var.function_tags
}
