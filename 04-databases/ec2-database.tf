module "mongodb_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "mongodb"
  ami                    = data.aws_ami.centos.image_id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = element(split(",", local.dbsubnet), 0)



  tags = merge(local.commontag,
    {
      Name             = "${local.name}-mongodb_db"
      Create_date_time = local.time
  })

}
resource "null_resource" "mongodb" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mongodb_instance.private_ip
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
    connection {
    type     = "ssh"
    user     = data.aws_ssm_parameter.ami_user.value
    password = data.aws_ssm_parameter.ami_password.value
    host     = module.mongodb_instance.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
       
       "sudo chmod +x /tmp/bootstrap.sh",
       "sh /tmp/bootstrap.sh mongodb dev"
  
  ]
  }
}
 module "redis_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "redis"
  ami                    = data.aws_ami.centos.image_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = element(split(",", local.dbsubnet), 0)
  iam_instance_profile = "shell_to_aws"
            #  create_iam_instance_profile = true
            #  iam_role_description        = "IAM role for EC2 instance"
            #  iam_role_policies = {
            #  AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
            #     }
               

  tags = merge(local.commontag,
    {
      Name             = "${local.name}-redis_db"
      Create_date_time = local.time
  })

}
resource "null_resource" "redis" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.redis_instance.private_ip
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
    connection {
    type     = "ssh"
    user     = data.aws_ssm_parameter.ami_user.value
    password = data.aws_ssm_parameter.ami_password.value
    host     = module.redis_instance.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
       
       "sudo chmod +x /tmp/bootstrap.sh",
       "sh /tmp/bootstrap.sh redis dev"
  
  ]
  }
}
module "mysql_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "mysql"
  ami                    = data.aws_ami.centos.image_id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = element(split(",", local.dbsubnet), 0)
  iam_instance_profile = "shell_to_aws"
        # create_iam_instance_profile = true
        # iam_role_description        = "IAM role for EC2 instance"
        # iam_role_policies = {
        # AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
        #        }


  tags = merge(local.commontag,
    {
      Name             = "${local.name}-mysql_db"
      Create_date_time = local.time
  })

}
resource "null_resource" "mysql" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mysql_instance.private_ip
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
    connection {
    type     = "ssh"
    user     = data.aws_ssm_parameter.ami_user.value
    password = data.aws_ssm_parameter.ami_password.value
    host     = module.mysql_instance.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
       
       "sudo chmod +x /tmp/bootstrap.sh",
       "sh /tmp/bootstrap.sh mysql dev"
  
  ]
  }
}
module "rabbitmq_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "rabbitmq"
  ami                    = data.aws_ami.centos.image_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = element(split(",", local.dbsubnet), 0)
  iam_instance_profile = "shell_to_aws"
   # create_iam_instance_profile = true
   # iam_role_description        = "IAM role for EC2 instance"
   # iam_role_policies = {
   #   AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
   # }


  tags = merge(local.commontag,
    {
      Name             = "${local.name}-rabbitmq_db"
      Create_date_time = local.time
  })

}
resource "null_resource" "rabbitmq" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.rabbitmq_instance.private_ip
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
    connection {
    type     = "ssh"
    user     = data.aws_ssm_parameter.ami_user.value
    password = data.aws_ssm_parameter.ami_password.value
    host     = module.rabbitmq_instance.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
       
       "sudo chmod +x /tmp/bootstrap.sh",
       "sh /tmp/bootstrap.sh rabbitmq dev"
  
  ]
  }
}
#################### ROUTE 53 records for dev #############################
module "mongodb-dev" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "mongodb-dev"
  type    = "A"
  ttl     = 1
  records = ["${module.mongodb_instance.private_ip}"]
}
module "redis-dev" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "redis-dev"
  type    = "A"
  ttl     = 1
  records = ["${module.redis_instance.private_ip}"]
}
module "mysql-dev" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "mysql-dev"
  type    = "A"
  ttl     = 1
  records = ["${module.mysql_instance.private_ip}"]
}
module "rabbitmq-dev" {
  source  = "../../terraform/terraform-aws-route53-module"
  zone_id = var.zone_id
  name    = "rabbitmq-dev"
  type    = "A"
  ttl     = 1
  records = ["${module.rabbitmq_instance.private_ip}"]
} 