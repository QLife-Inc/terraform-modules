variable "distribution_enabled" {
  description = "この CloudFront ディストリビューションを有効にするかどうか (デフォルト: 有効)"
  default     = true
}

variable "ipv6_enabled" {
  description = "IPv6 によるアクセスを有効にするかどうか (デフォルト: IPv6有効)"
  default     = true
}

variable "distribution_comment" {
  description = "CloudFront ディストリビューションのコメント (Origin Access Identityと共用)"
  default     = ""
}

variable "default_root_object" {
  description = "ディレクトリにアクセスした際に呼び出されるファイル (デフォルト: index.html)"
  default     = "index.html"
}

variable "logging_config" {
  type = object({
    bucket          = string
    prefix          = string
    include_cookies = bool
  })
  description = "アクセスログを格納する S3 バケットの情報 (デフォルト: なし)"
  default     = null
}

variable "origin_bucket_name" {
  description = "オリジン S3 バケット名"
}

variable "domain_names" {
  type        = list(string)
  description = "CloudFront に関連付けるドメイン名のリスト"
}

variable "s3_origin_id" {
  description = "S3 オリジンのオリジンID (省略した場合はバケット名)"
  default     = ""
}

variable "s3_origin_path" {
  description = "S3 バケットのルートパス (省略した場合はバケットルート)"
  default     = ""
}

variable "distribution_tags" {
  type        = map(string)
  description = "CloudFront ディストリビューションに設定するタグ"
  default     = {}
}

variable "viewer_protocol_policy" {
  description = "HTTPアクセス時の挙動 [allow-all/https-only/redirect-to-https] (デフォルト: allow-all)"
  default     = "allow-all"
}

variable "compress" {
  description = "gzip 圧縮を有効にするかどうか (デフォルト: true)"
  default     = true
}

variable "min_ttl" {
  description = "キャッシュ保持期間の最小秒数 (デフォルト: 0)"
  default     = 0
}

variable "default_ttl" {
  description = "キャッシュ保持期間のデフォルト秒数 (デフォルト: 3600)"
  default     = 3600
}

variable "max_ttl" {
  description = "キャッシュ保持期間の最大秒数 (デフォルト: 86400)"
  default     = 86400
}

variable "price_class" {
  description = "CloudFront ディストリビューションの Price Class (デフォルト: オーストラリア・南米以外)"
  default     = "PriceClass_200"
}

variable "not_found_caching_min_ttl" {
  description = "Not Found リクエストのキャッシュ最小秒数 (デフォルト: 0)"
  default     = 0
}

variable "not_found_page_path" {
  description = "Not Found のページパス (デフォルト: 404.html)"
  default     = "/404.html"
}

variable "geo_restriction_type" {
  description = "配信地域制限のタイプ [whitelist/blacklist/none] (デフォルト: none)"
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "配信地域のホワイトリストもしくはブラックリスト"
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM 証明書の ARN (必ず us-east-1 で作成されていること)"
  default     = ""
}

variable "minimum_protocol_version" {
  description = "クライアントに強要する最小のTLSバージョン (デフォルト: TLSv1.2_2018)"
  default     = "TLSv1.2_2018"
}

variable "lambda_function_associations" {
  type = list(object({
    event_type   = string
    lambda_arn   = string
    include_body = bool
  }))
  description = "関連付ける Lambda@Edge 関数のリスト (デフォルト: なし)"
  default     = []
}

variable "hosted_zone_id" {
  description = "ALIAS レコードを追加する Route53 の Hosted Zone Id"
}
