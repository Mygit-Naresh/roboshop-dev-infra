module "catalogue_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = var.tags.component

  instance_type          = var.instance_type
  ami                    = data.aws_ami.centos.image_id
  vpc_security_group_ids = [local.catalogue_sg]
  subnet_id              = element(split(",", local.privatesubnet), 0)

  tags = merge(local.commontag,
    {
      Name             = "${local.name}-${var.tags.component}-AMI"
      Create_date_time = local.time
  })

}
 
resource "null_resource" "catalogue_config" {
 
  triggers = {
    instance_id = module.catalogue_instance.id
  }

  
    connection {
    type     = "ssh"
    user     = data.aws_ssm_parameter.ami_user.value
    password = data.aws_ssm_parameter.ami_password.value
    host     = module.catalogue_instance.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
       
       "sudo chmod +x /tmp/bootstrap.sh",
       "sh /tmp/bootstrap.sh catalogue dev"
  
  ]
  }
}
resource "aws_ec2_instance_state" "catalogue_stop" {
  instance_id = module.catalogue_instance.id
  state       = "stopped"
  depends_on = [ null_resource.catalogue_config ]
}
resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "terraform-${var.tags.component}-AMI"
  source_instance_id =  module.catalogue_instance.id
   depends_on = [ aws_ec2_instance_state.catalogue_stop ]

  tags = merge(var.common_tags,  
    {
     Name = "${var.project}-${var.environment}-${var.tags.component}-AMI"   
  })
}
resource "null_resource" "catalogue_terminate" {

 triggers = {
    instance_id =  module.catalogue_instance.id
}

  provisioner "local-exec" {
   
       
      command =  "aws ec2 terminate-instances --instance-ids ${module.catalogue_instance.id}"
  }
      depends_on = [ aws_ami_from_instance.catalogue_ami ]
}
  
resource "aws_launch_template" "catalogue_lt" {
  name_prefix   = "${var.tags.component}-LT"
  image_id      = aws_ami_from_instance.catalogue_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  
  
  tags = {
    Name = "${local.name}-${var.tags.component}-launchtemplate"
  }
  
}
resource "aws_autoscaling_group" "asg-catalogue" {
  name                      = "ASG-${var.tags.component}"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          =  2
  vpc_zone_identifier       = split(",", local.privatesubnet)
  launch_template {
    id      = aws_launch_template.catalogue_lt.id
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
    value               = "Autoscale-${var.tags.component}-${local.time}"
    propagate_at_launch = true
  }

}

resource "aws_lb_listener_rule" "aws-lb-rule" {
  listener_arn = data.aws_ssm_parameter.app-lb-listener_arn.value
  priority     = 1
  

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue_tg.arn
  }

  

  condition {
    host_header {
      values = ["${var.tags.component}.app-${var.environment}.${var.zone_name}"]
    }
  }


 tags = merge(local.commontag,
    {
      Name             = "${local.name}-app-lb-listner_rule"
      Create_date_time = local.time
  })

}

resource "aws_lb_target_group" "catalogue_tg" { // Target Group catalogue
 name     = "${var.project}-${var.environment}-${var.tags.component}-tg"
 port     = 8080
 protocol = "HTTP"
 vpc_id   = data.aws_ssm_parameter.vpc_id.value
 deregistration_delay = 60
 
 health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
    interval = 10
    
  } 

}
 
resource "aws_autoscaling_attachment" "lb_attachment_to_tg" {
  autoscaling_group_name = aws_autoscaling_group.asg-catalogue.name
  lb_target_group_arn    = aws_lb_target_group.catalogue_tg.arn
}

resource "aws_autoscaling_policy" "avg_cpu_scaling_policy" {
 
  name                   = "avg-cpu-scling-policy"
  policy_type = "TargetTrackingScaling" 
  autoscaling_group_name = aws_autoscaling_group.asg-catalogue.name
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
#   autoscaling_group_name = aws_autoscaling_group.asg-catalogue.name
#   name                   = "catalogue-ASG"
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
#                 name  = aws_autoscaling_group.asg-catalogue.name
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

