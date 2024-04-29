resource "aws_ssm_parameter" "app-lb-listener_arn" {
  name  = "/${var.project}/${var.environment}/app-lb-listener_arn"
  type  = "String"
  value =  aws_lb_listener.app-lb-listener.arn
}



