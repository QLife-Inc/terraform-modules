variable "role_name" {
  description = "Lambda@Edge 関数に設定する IAM ロール名"
  default     = "cf-edge-function-role"
}

variable "role_tags" {
  type        = map(string)
  description = "Lambda@Edge 関数に設定する IAM ロールのタグ"
  default     = {}
}
