variable "aws_region" {
  description = "S3 バケットのリージョン (デフォルト: 東京)"
  default     = "ap-northeast-1"
}

variable "bucket_name" {
  description = "S3 バケット名"
}

variable "bucket_tags" {
  type        = map(string)
  description = "S3 バケットに付与するタグ"
  default     = {}
}

variable "force_destroy" {
  description = "オブジェクトが存在する場合に強制的に削除するかどうか (デフォルト: true)"
  default     = true
}
