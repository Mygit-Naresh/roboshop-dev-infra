# module "ansible" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "ansible"
#   ami                    = data.aws_ami.centos.image_id
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [local.vpn_sg]
#   subnet_id              = data.aws_subnet.default.id
#   user_data = file("ansible.sh")


#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-ansible"
#       Create_date_time = local.time
#   })

# }
# module "mongodb_instance" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "mongodb"
#   ami                    = data.aws_ami.centos.image_id
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [local.mongodb_sg]
#   subnet_id              = element(split(",", local.dbsubnet), 0)


#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-mongodb_db"
#       Create_date_time = local.time
#   })

# }
# module "redis_instance" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "redis"
#   ami                    = data.aws_ami.centos.image_id
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
#   subnet_id              = element(split(",", local.dbsubnet), 0)


#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-redis_db"
#       Create_date_time = local.time
#   })

# }
# module "mysql_instance" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "mysql"
#   ami                    = data.aws_ami.centos.image_id
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
#   subnet_id              = element(split(",", local.dbsubnet), 0)


#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-mysql_db"
#       Create_date_time = local.time
#   })

# }
# module "rabbitmq_instance" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "rabbitmq"
#   ami                    = data.aws_ami.centos.image_id
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
#   subnet_id              = element(split(",", local.dbsubnet), 0)


#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-rabbitmq_db"
#       Create_date_time = local.time
#   })

# }
# module "catalogue_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"
#   name   = "catalogue"

#   instance_type          = "t2.micro"
#   ami                    = data.aws_ami.centos.image_id
#   vpc_security_group_ids = [local.catalogue_sg]
#   subnet_id              = element(split(",", local.privatesubnet), 0)

#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-catalogue_back"
#       Create_date_time = local.time
#   })

# }
# module "cart_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"
#   name   = "cart"

#   instance_type          = "t2.micro"
#   ami                    = data.aws_ami.centos.image_id
#   vpc_security_group_ids = [local.cart_sg]
#   subnet_id              = element(split(",", local.privatesubnet), 0)

#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-cart_back"
#       Create_date_time = local.time
#   })

# }
# module "user_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"
#   name   = "user"

#   instance_type          = "t2.micro"
#   ami                    = data.aws_ami.centos.image_id
#   vpc_security_group_ids = [local.user_sg]
#   subnet_id              = element(split(",", local.privatesubnet), 0)

#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-user_back"
#       Create_date_time = local.time
#   })

# }
# module "payment_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"
#   name   = "payment"

#   instance_type          = "t2.micro"
#   ami                    = data.aws_ami.centos.image_id
#   vpc_security_group_ids = [local.payment_sg]
#   subnet_id              = element(split(",", local.privatesubnet), 0)

#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-payment_back"
#       Create_date_time = local.time
#   })

# }
# module "shipping_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"
#   name   = "shipping"

#   instance_type          = "t3.small"
#   ami                    = data.aws_ami.centos.image_id
#   vpc_security_group_ids = [local.shipping_sg]
#   subnet_id              = element(split(",", local.privatesubnet), 0)

#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-shipping_back"
#       Create_date_time = local.time
#   })

# }
# module "web_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"
#   name   = "web"

#   instance_type          = "t2.micro"
#   ami                    = data.aws_ami.centos.image_id
#   vpc_security_group_ids = [local.web_sg]
#   subnet_id              = element(split(",", local.publicsubnet), 0)

#   tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-web_front"
#       Create_date_time = local.time
#   })

# }
############### AWS ROUTE 53 ###################
module "mongodb_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = "Z101265833JA5X90XBKK8"
  name    = "mongodb"
  type    = "A"
  ttl     = 1
  records = ["${module.mongodb_instance.private_ip}"]
}
module "redis_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "redis"
  type    = "A"
  ttl     = 1
  records = ["${module.redis_instance.private_ip}"]
}
module "mysql_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "mysql"
  type    = "A"
  ttl     = 1
  records = ["${module.mysql_instance.private_ip}"]
}
module "rabbitmq_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "rabbitmq"
  type    = "A"
  ttl     = 1
  records = ["${module.rabbitmq_instance.private_ip}"]
}
module "catalogue_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "catalogue"
  type    = "A"
  ttl     = 1
  records = ["${module.catalogue_instance.private_ip}"]
}
module "cart_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "cart"
  type    = "A"
  ttl     = 1
  records = ["${module.cart_instance.private_ip}"]
}
module "user_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "user"
  type    = "A"
  ttl     = 1
  records = ["${module.user_instance.private_ip}"]
}
module "payment_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "payment"
  type    = "A"
  ttl     = 1
  records = ["${module.payment_instance.private_ip}"]
}
module "shipping_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "shipping"
  type    = "A"
  ttl     = 1
  records = ["${module.shipping_instance.private_ip}"]
}
module "web_dns" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "web"
  type    = "A"
  ttl     = 1
  records = ["${module.web_instance.private_ip}"]
}
