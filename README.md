# terraform-modules

汎用的な Terraform モジュールのリポジトリ。

## log_bucket モジュール

CloudFront や ELB などのアクセスログを格納するための S3 バケットを作成する。

## public_domain モジュール

Route53 Hosted Zone および ACM 証明書を作成する。

## static_site モジュール

静的サイトを S3 + CloudFront で配信するための S3 バケットおよび CloudFront ディストリビューションを作成する。  
また、テスト環境など IP 制限が必要な場合に簡易 IP 制限のための Lambda@Edge 関数を作成する。
