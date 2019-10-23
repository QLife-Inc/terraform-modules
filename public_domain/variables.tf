// Route53 Hosted Zone

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

variable "zone_force_destroy" {
  description = "削除時にレコードがあっても削除するかどうか (デフォルト: 削除する)"
  default     = true
}

variable "ns_records" {
  type        = list(string)
  description = "サブドメインの Hosted Zone の場合、親の NS レコード"
  default     = []
}

variable "ns_record_ttl" {
  description = "サブドメインの場合の NS レコードの TTL"
  default     = 3600
}

// ACM 証明書

variable "cert_region" {
  description = "証明書を発行するリージョン"
}

variable "cert_subject_alternative_names" {
  type        = list(string)
  description = "証明書に追加するドメイン名のリスト"
  default     = []
}

variable "cert_tags" {
  type        = map(string)
  description = "証明書に設定するタグ"
  default     = {}
}

variable "cert_validation_record_ttl" {
  description = "Route53 DNS 検証レコードの TTL (デフォルト: 60)"
  default     = 300
}
