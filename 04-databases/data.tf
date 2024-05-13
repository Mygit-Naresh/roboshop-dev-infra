data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.environment}/mongodb_sg_id"
}
data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"
}
data "aws_ami" "centos" {
  most_recent = true
  owners      = ["973714476881"]
  filter {
    name   = "name"
    values = ["Centos-8-*"]
  }
}
data "aws_ssm_parameter" "db_subnet_ids" {
  name = "/${var.project}/${var.environment}/db_subnet_ids"
}
data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.environment}/redis_sg_id"
}
data "aws_ssm_parameter" "ami_user" {
    name = "/${var.project}/${var.environment}/ami_user"
}
data "aws_ssm_parameter" "ami_password" {
    name = "/${var.project}/${var.environment}/ami_password"
}
data "aws_ssm_parameter" "rabbitmq_sg_id" {
    name = "/${var.project}/${var.environment}/rabbitmq_sg_id"
}
data "aws_ssm_parameter" "vpn_sg_id" {
    name = "/${var.project}/${var.environment}/vpn_sg_id"
}