variable "domain_name" {
  description = "ドメイン名"
}

variable "hosted_zone_comment" {
  description = "Hosted Zone のコメント"
  default     = ""
}

variable "hosted_zone_tags" {
  type        = map(string)
  description = "Hosted Zone に設定するタグ"
  default     = {}
}

variable "force_destroy" {
  description = "削除時にレコードがあっても削除するかどうか (デフォルト: 削除する)"
  default     = true
}
