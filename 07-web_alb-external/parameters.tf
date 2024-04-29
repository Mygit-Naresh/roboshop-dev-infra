resource "aws_ssm_parameter" "web_tg_arn" {
  name  = "/${var.project}/${var.environment}/web_tg_arn"
  type  = "String"
  value =  aws_lb_target_group.web_tg.arn
}
resource "aws_ssm_parameter" "web_alb_dns_name" {
  name  = "/${var.project}/${var.environment}/web_alb_dns_name"
  type  = "String"
  value =  aws_lb.web_alb.dns_name
}
resource "aws_ssm_parameter" "web_alb_zone_id" {
  name  = "/${var.project}/${var.environment}/web_alb_zone_id"
  type  = "String"
  value =  aws_lb.web_alb.zone_id
}


