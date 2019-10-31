// 静的サイト格納 S3 バケット

variable "site_bucket_region" {
  description = "静的サイト格納用 S3 バケットのリージョン (デフォルト: 東京)"
  default     = "ap-northeast-1"
}

variable "site_bucket_name" {
  description = "静的サイト格納用の S3 バケット名"
}

variable "site_bucket_tags" {
  type        = map(string)
  description = "静的サイト格納用の S3 バケットに付与するタグ"
  default     = {}
}

variable "site_bucket_force_destroy" {
  description = "静的サイト格納用の S3 バケットにオブジェクトが存在する場合に強制的に削除するかどうか (デフォルト: true)"
  default     = true
}

// Lambda@Edge 関数用の IAM Role

variable "edge_function_role_name" {
  description = "Lambda@Edge 関数に設定する IAM ロール名"
  default     = "cf-edge-function-role"
}

variable "edge_function_role_tags" {
  type        = map(string)
  description = "Lambda@Edge 関数に設定する IAM ロールのタグ"
  default     = {}
}

// DirectoryIndex 用の Lambda@Edge

variable "directory_index_function_name" {
  description = "DirectoryIndex 制御を行う Lambda@Edge 関数の名前"
  default     = "cf-s3-directory-index"
}

variable "directory_index_function_tags" {
  type        = map(string)
  description = "DirectoryIndex 制御を行う Lambda@Edge 関数に設定する タグ"
  default     = {}
}

// IP 制限用の Lambda@Edge

variable "restrict_ips_function_name" {
  description = "IP 制限を行う Lambda@Edge 関数の名前"
  default     = "restrict-ips-on-viewer-request"
}

variable "restrict_ips_function_tags" {
  type        = map(string)
  description = "IP 制限を行う Lambda@Edge 関数に設定する タグ"
  default     = {}
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "CloudFront 経由でのアクセスを許可する IP アドレスのリスト"
  default     = []
}

// CloudFront

variable "cf_distribution_enabled" {
  description = "CloudFront ディストリビューションを有効にするかどうか (デフォルト: 有効)"
  default     = true
}

variable "cf_ipv6_enabled" {
  description = "IPv6 によるアクセスを有効にするかどうか (デフォルト: IPv6有効)"
  default     = true
}

variable "cf_distribution_comment" {
  description = "CloudFront ディストリビューションのコメント (Origin Access Identityと共用)"
  default     = ""
}

variable "cf_default_root_object" {
  description = "ディレクトリにアクセスした際に呼び出されるファイル (デフォルト: index.html)"
  default     = "index.html"
}

variable "cf_logging_config" {
  type = object({
    bucket          = string
    prefix          = string
    include_cookies = bool
  })
  description = "アクセスログを格納する S3 バケットの情報 (デフォルト: なし)"
  default     = null
}

variable "cf_domain_names" {
  type        = list(string)
  description = "CloudFront に関連付けるドメイン名のリスト"
}

variable "cf_s3_origin_id" {
  description = "S3 オリジンのオリジンID (省略した場合はバケット名)"
  default     = ""
}

variable "cf_s3_origin_path" {
  description = "S3 バケットのルートパス (省略した場合はバケットルート)"
  default     = ""
}

variable "cf_distribution_tags" {
  type        = map(string)
  description = "CloudFront ディストリビューションに設定するタグ"
  default     = {}
}

variable "cf_viewer_protocol_policy" {
  description = "HTTPアクセス時の挙動 [allow-all/https-only/redirect-to-https] (デフォルト: allow-all)"
  default     = "allow-all"
}

variable "cf_compress" {
  description = "gzip 圧縮を有効にするかどうか (デフォルト: true)"
  default     = true
}

variable "cf_min_ttl" {
  description = "キャッシュ保持期間の最小秒数 (デフォルト: 0)"
  default     = 0
}

variable "cf_default_ttl" {
  description = "キャッシュ保持期間のデフォルト秒数 (デフォルト: 3600)"
  default     = 3600
}

variable "cf_max_ttl" {
  description = "キャッシュ保持期間の最大秒数 (デフォルト: 86400)"
  default     = 86400
}

variable "cf_price_class" {
  description = "CloudFront ディストリビューションの Price Class (デフォルト: オーストラリア・南米以外)"
  default     = "PriceClass_200"
}

variable "cf_not_found_caching_min_ttl" {
  description = "Not Found リクエストのキャッシュ最小秒数 (デフォルト: 0)"
  default     = 0
}

variable "cf_not_found_page_path" {
  description = "Not Found のページパス (デフォルト: 404.html)"
  default     = "/404.html"
}

variable "cf_geo_restriction_type" {
  description = "配信地域制限のタイプ [whitelist/blacklist/none] (デフォルト: none)"
  default     = "none"
}

variable "cf_geo_restriction_locations" {
  description = "配信地域のホワイトリストもしくはブラックリスト"
  default     = []
}

variable "cf_acm_certificate_arn" {
  description = "ACM 証明書の ARN (必ず us-east-1 で作成されていること)"
  default     = ""
}

variable "cf_minimum_protocol_version" {
  description = "クライアントに強要する最小のTLSバージョン (デフォルト: TLSv1.2_2018)"
  default     = "TLSv1.2_2018"
}

variable "cf_hosted_zone_id" {
  description = "CloudFront のドメインを登録する Route53 Hosted Zone の ID"
}
