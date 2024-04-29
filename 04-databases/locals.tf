locals {
  name = "${var.project}-${var.environment}"
  time = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
}
locals {
  commontag = var.common_tags
}
locals {
  dbsubnet      = data.aws_ssm_parameter.db_subnet_ids.value
}