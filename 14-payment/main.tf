module "payment" {
 source =  "../roboshop-backend-module"
 tags = var.tags
 common_tags = var.common_tags
 project = var.project
 environment = var.environment
 private_subnet_id = element(split(",",data.aws_ssm_parameter.private_subnet_ids.value),0)
 name =  var.name
 ami = data.aws_ami.centos.image_id
 ami_user =  data.aws_ssm_parameter.ami_user.value
 ami_password =  data.aws_ssm_parameter.ami_password.value
 vpc_security_group_ids = data.aws_ssm_parameter.payment_sg_id.value
 zone_id = var.zone_id
 zone_name = var.zone_name
 instance_type = var.instance_type
 priority = var.priority
 app_listener_arn = data.aws_ssm_parameter.app-lb-listener_arn.value
 port = "8080"
 }


