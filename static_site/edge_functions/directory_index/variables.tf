variable "function_name" {
  description = "Lambda@Edge 関数の名前"
  default     = "cf-s3-directory-index"
}

variable "function_tags" {
  type        = map(string)
  description = "Lambda@Edge 関数に設定する タグ"
  default     = {}
}

variable "function_role_arn" {
  description = "Lambda@Edge 関数に設定する IAM ロールの ARN"
}
