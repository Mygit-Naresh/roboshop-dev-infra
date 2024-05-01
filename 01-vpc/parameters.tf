resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project}/${var.environment}/vpc_id"
  type  = "String"
  value = module.useterraform.vpc_id
}
resource "aws_ssm_parameter" "publicsubnet" {

  name  = "/${var.project}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",",module.useterraform.public_subnet_ids)
}
resource "aws_ssm_parameter" "dbsubnet" {

  name  = "/${var.project}/${var.environment}/db_subnet_ids"
  type  = "StringList"
  value = join(",",module.useterraform.db_subnet_ids)
}
resource "aws_ssm_parameter" "privatesubnet" {

  name  = "/${var.project}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",",module.useterraform.private_subnet_ids)
}



output "output_public_subnet_ids"  {
      value = module.useterraform.public_subnet_ids
}
output "vpc_id"  {
      value = module.useterraform.vpc_id
}


