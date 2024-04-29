data  "aws_ssm_parameter" "eternaldomain_certificate_arn" {
    name = "/${var.project}/${var.environment}/eternaldomain_certificate_arn"
}
data "aws_ssm_parameter" "web_alb_dns_name" {
  name = "/${var.project}/${var.environment}/web_alb_dns_name"
}
data "aws_ssm_parameter" "web_alb_zone_id" {
  name = "/${var.project}/${var.environment}/web_alb_zone_id"
}
data "aws_cloudfront_cache_policy" "cache" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "no_cache" {
  name = "Managed-CachingDisabled"
}

