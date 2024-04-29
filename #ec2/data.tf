data "aws_ssm_parameter" "vpn_sg_id" {
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
data "aws_ami" "centos" {
  most_recent = true
  owners      = ["973714476881"]
  filter {
    name   = "name"
    values = ["Centos-8-*"]
  }
}
data "aws_vpc"  "default" {
    default = "true"
}
data "aws_subnet"  "default" {
   vpc_id = data.aws_vpc.default.id
   availability_zone = "us-east-1a"
}
