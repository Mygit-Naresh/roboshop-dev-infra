locals {
  name = "${var.project}-${var.environment}"
  time = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
}
locals {
  commontag = var.common_tags
}
locals {
  dbsubnet      = data.aws_ssm_parameter.db_subnet_ids.value
  privatesubnet = data.aws_ssm_parameter.private_subnet_ids.value
  publicsubnet  = data.aws_ssm_parameter.public_subnet_ids.value
}
locals {
  mongodb_sg   = data.aws_ssm_parameter.mongodb_sg_id.value
  catalogue_sg = data.aws_ssm_parameter.catalogue_sg_id.value
}

locals {
  user_sg     = data.aws_ssm_parameter.user_sg_id.value
  cart_sg     = data.aws_ssm_parameter.cart_sg_id.value
  shipping_sg = data.aws_ssm_parameter.shipping_sg_id.value
  payment_sg  = data.aws_ssm_parameter.payment_sg_id.value
  web_sg      = data.aws_ssm_parameter.web_sg_id.value
  vpn_sg      = data.aws_ssm_parameter.vpn_sg_id.value
}

