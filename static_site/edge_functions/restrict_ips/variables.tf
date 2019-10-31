variable "function_name" {
  description = "Lambda@Edge 関数の名前"
  default     = "restrict-ips-on-viewer-request"
}

variable "function_tags" {
  type        = map(string)
  description = "Lambda@Edge 関数に設定する タグ"
  default     = {}
}

variable "function_role_arn" {
  description = "Lambda@Edge 関数に設定する IAM ロールの ARN"
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "CloudFront 経由でのアクセスを許可する IP アドレスのリスト"
  default     = []
}
