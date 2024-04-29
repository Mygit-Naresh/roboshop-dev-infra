resource "aws_ssm_parameter" "web_alb_sg_id" {
  name  = "/${var.project}/${var.environment}/web_alb_sg_id"
  type  = "StringList"
  value =  module.web_alb.sg_id
}
resource "aws_ssm_parameter" "app-lb_sg_id" {
  name  = "/${var.project}/${var.environment}/app-lb_sg_id"
  type  = "StringList"
  value =  module.app-lb.sg_id
}
resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project}/${var.environment}/vpn_sg_id"
  type  = "StringList"
  value =  module.vpn.sg_id
}
resource "aws_ssm_parameter" "mongodb_sg_id" {
  name  = "/${var.project}/${var.environment}/mongodb_sg_id"
  type  = "StringList"
  value =  module.mongodb.sg_id
}
resource "aws_ssm_parameter" "catalogue_sg_id" {
  name  = "/${var.project}/${var.environment}/catalogue_sg_id"
  type  = "String"
  value =  module.catalogue.sg_id
}
resource "aws_ssm_parameter" "user_sg_id" {
  name  = "/${var.project}/${var.environment}/user_sg_id"
  type  = "String"
  value =  module.user.sg_id
}
resource "aws_ssm_parameter" "cart_sg_id" {
  name  = "/${var.project}/${var.environment}/cart_sg_id"
  type  = "String"
  value =  module.cart.sg_id
}
resource "aws_ssm_parameter" "redis_sg_id" {
  name  = "/${var.project}/${var.environment}/redis_sg_id"
  type  = "String"
  value =  module.redis.sg_id
}
resource "aws_ssm_parameter" "rabbitmq_sg_id" {
  name  = "/${var.project}/${var.environment}/rabbitmq_sg_id"
  type  = "String"
  value =  module.rabbitmq.sg_id
}
resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${var.project}/${var.environment}/mysql_sg_id"
  type  = "String"
  value =  module.mysql.sg_id
}
resource "aws_ssm_parameter" "payment_sg_id" {
  name  = "/${var.project}/${var.environment}/payment_sg_id"
  type  = "String"
  value =  module.payment.sg_id
}
resource "aws_ssm_parameter" "shipping_sg_id" {
  name  = "/${var.project}/${var.environment}/shipping_sg_id"
  type  = "String"
  value =  module.shipping.sg_id
}
resource "aws_ssm_parameter" "ratings_sg_id" {
  name  = "/${var.project}/${var.environment}/ratings_sg_id"
  type  = "String"
  value =  module.ratings.sg_id
}
resource "aws_ssm_parameter" "web_sg_id" {
  name  = "/${var.project}/${var.environment}/web_sg_id"
  type  = "String"
  value =  module.web.sg_id
}
