# cloudfront_s3

静的サイト配信を行うための S3 をオリジンとした CloudFront の構築モジュールです。

純粋な静的サイトの配信のみを想定しているため、`default_cache_behavior`のみをサポートします。
