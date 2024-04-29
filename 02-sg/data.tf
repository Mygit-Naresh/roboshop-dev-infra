data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

# data "aws_default_security_group" "selected" {
#   id = data.aws_security_group.selected.id
# }
# output "vpn_sg_id" {
#   value = data.aws_security_group.default_sg.id
# }
data "aws_vpc" "default" {
  default = "true"
}
/* data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project}/${var.environment}/vpn_sg_id"
}
data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.environment}/mongodb_sg_id"
}
data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue_sg_id"
}
data "aws_ssm_parameter" "cart_sg_id" {
  name = "/${var.project}/${var.environment}/cart_sg_id"
}
data "aws_ssm_parameter" "user_sg_id" {
  name = "/${var.project}/${var.environment}/user_sg_id"
}
data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.environment}/redis_sg_id"
}
data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"
}
data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.environment}/rabbitmq_sg_id"
}
data "aws_ssm_parameter" "payment_sg_id" {
  name = "/${var.project}/${var.environment}/payment_sg_id"
}
data "aws_ssm_parameter" "shipping_sg_id" {
  name = "/${var.project}/${var.environment}/shipping_sg_id"
}
data "aws_ssm_parameter" "ratings_sg_id" {
  name = "/${var.project}/${var.environment}/ratings_sg_id"
}
data "aws_ssm_parameter" "web_sg_id" {
  name = "/${var.project}/${var.environment}/web_sg_id"
}
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}
data "aws_ssm_parameter" "db_subnet_ids" {
  name = "/${var.project}/${var.environment}/db_subnet_ids"
}
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}
 */
