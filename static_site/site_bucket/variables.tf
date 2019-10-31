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

variable "cors_allowed_origins" {
  type        = list(string)
  description = "CORS で許可するドメインのリスト"
  default     = ["*"]
}

variable "force_destroy" {
  description = "オブジェクトが存在する場合に強制的に削除するかどうか (デフォルト: true)"
  default     = true
}

variable "index_document" {
  default = "index.html"
}

variable "error_document" {
  default = null
}

variable "routing_rules" {
  type = list(object({
    condition = map(string)
    redirect  = map(string)
  }))
  description = "S3 バケットに設定するリダイレクトルール"
  default     = []
}
