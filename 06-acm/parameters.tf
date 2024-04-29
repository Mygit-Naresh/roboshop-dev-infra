resource "aws_ssm_parameter" "eternaldomain_certificate_arn" {
  name  = "/${var.project}/${var.environment}/eternaldomain_certificate_arn"
  type  = "String"
  value =  aws_acm_certificate.eternaldomain_certificate.arn
}
