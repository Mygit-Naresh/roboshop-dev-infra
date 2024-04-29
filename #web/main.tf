module "web_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = var.tags.component

  instance_type          = "t2.micro"
  ami                    = data.aws_ami.centos.image_id
  vpc_security_group_ids = [data.aws_ssm_parameter.web_sg_id.value]
  subnet_id              =  element(split(",", data.aws_ssm_parameter.private_subnet_ids.value),0)

  tags = merge(local.commontag,
    {
      Name             = "${local.name}-ami-web-${local.time}"
      Create_date_time = local.time
  })

}
 
resource "null_resource" "web_config" {
 
  triggers = {
    instance_id = module.web_instance.id
  }

  
    connection {
    type     = "ssh"
    user     = data.aws_ssm_parameter.ami_user.value
    password = data.aws_ssm_parameter.ami_password.value
    host     = module.web_instance.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
       
       "sudo chmod +x /tmp/bootstrap.sh",
       "sh /tmp/bootstrap.sh web dev"
  
  ]
  }
}
resource "aws_ec2_instance_state" "web_stop" {
  instance_id = module.web_instance.id
  state       = "stopped"
  depends_on = [ null_resource.web_config ]
}
resource "aws_ami_from_instance" "web_ami" {
  name               = "terraform-web_ami"
  source_instance_id =  module.web_instance.id
   depends_on = [ aws_ec2_instance_state.web_stop ]

  tags = merge(var.common_tags,  
    {
     Name = "${var.project}-${var.environment}-${var.tags.component}-ami"   
  })
}
resource "null_resource" "web_terminate" {

 triggers = {
    instance_id =  module.web_instance.id
}

  provisioner "local-exec" {
   
       
      command =  "aws ec2 terminate-instances --instance-ids ${module.web_instance.id}"
  }
      depends_on = [ aws_ami_from_instance.web_ami ]
}
  
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-LT-ami-v1"
  image_id      = aws_ami_from_instance.web_ami.id
  instance_type = "t2.micro"
  default_version = "1"
  vpc_security_group_ids = [data.aws_ssm_parameter.web_sg_id.value]
  
  
  tags = {
    Name = "${local.name}-${var.tags.component}-launchtemplate"
  }
  
}
resource "aws_autoscaling_group" "asg-web" {
  name                      = "ASG-web"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = split(",", local.privatesubnet)
  launch_template {
    id      = aws_launch_template.web_lt.id
    version =  "$Latest"
  }
    
   instance_refresh {
      strategy = "Rolling"
      preferences  {
        min_healthy_percentage = 50
      }

      triggers = [ "launch_template" ]
       
   }

  tag {
    key                 = "Name"
    value               = "Autoscale-web-${local.time}"
    propagate_at_launch = true
  }

}


 
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.asg-web.name
  lb_target_group_arn    = data.aws_ssm_parameter.web_tg_arn.value
}

resource "aws_autoscaling_policy" "avg_cpu_scaling_policy" {
 
  name                   = "avg-cpu-scling-policy"
  policy_type = "TargetTrackingScaling" 
  autoscaling_group_name = aws_autoscaling_group.asg-web.name
  estimated_instance_warmup = 60
  # CPU Utilization is above 50
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }  
}
# resource "aws_autoscaling_policy" "example" {
#   autoscaling_group_name = aws_autoscaling_group.asg-.name
#   name                   = "-ASG"
#   policy_type            = "PredictiveScaling"
#   predictive_scaling_configuration {
#     metric_specification {
#       target_value = 50
#       predefined_load_metric_specification {
#         predefined_metric_type = "ASGTotalCPUUtilization"
#         resource_label         = "app/my-alb/778d41231b141a0f/targetgroup/my-alb-target-group/943f017f100becff"
#       }
#       customized_scaling_metric_specification {
#         metric_data_queries {
#           id = "scaling"
#           metric_stat {
#             metric {
#               metric_name = "CPUUtilization"
#               namespace   = "AWS/EC2"
#               dimensions {
#                 name  = aws_autoscaling_group.asg-.name
#                 value = "my-test-asg"
#               }
#             }
#             stat = "Average"
#           }
#         }
#       }
#     }
#   }
# }

