resource "aws_route53_zone" "hosted_zone" {
  name          = var.domain_name
  comment       = var.hosted_zone_comment
  tags          = var.hosted_zone_tags
  force_destroy = var.force_destroy
}
