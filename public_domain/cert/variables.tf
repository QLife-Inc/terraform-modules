variable "domain_name" {
  description = "証明書の Common Name"
}

variable "subject_alternative_names" {
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
  default     = 60
}
