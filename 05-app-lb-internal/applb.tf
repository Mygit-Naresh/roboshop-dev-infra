resource "aws_lb" "app-lb" {
 name               = "app-lb"
 internal           = true
 load_balancer_type = "application"
 security_groups    = [data.aws_ssm_parameter.app-lb_sg_id.value]
 subnets            = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
 

 tags = merge(local.commontag,
    {
      Name             = "${local.name}-app-lb"
      Create_date_time = local.time
  })

}
resource "aws_lb_listener" "app-lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

# resource "aws_lb_listener_rule" "aws-lb-rule" {
#   listener_arn = aws_lb_listener.app-lb-listener.arn
#   priority     = 1

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.catalogue_tg.arn
#   }

  

#   condition {
#     host_header {
#       values = ["catalogue.app-dev.eternaltrainings.online"]
#     }
#   }


#  tags = merge(local.commontag,
#     {
#       Name             = "${local.name}-app-lb-listner_rule"
#       Create_date_time = local.time
#   })

# }

resource "aws_route53_record" "app-lb-record" {
  zone_id = var.zone_id
  name    = "*.app-dev" 
  type    = "A" # OR "AAAA"

  alias {
      name                   = aws_lb.app-lb.dns_name
      zone_id                = aws_lb.app-lb.zone_id
      evaluate_target_health = true
  }
}
# resource "aws_lb_target_group" "catalogue_tg" { // Target Group catalogue
#  name     = "${var.project}-${var.environment}-catalogue-tg"
#  port     = 8080
#  protocol = "HTTP"
#  vpc_id   = data.aws_ssm_parameter.vpc_id.value
 
 
#  health_check {
#     path                = "/health"
#     port                = 8080
#     protocol            = "HTTP"
#     healthy_threshold   = 10
#     unhealthy_threshold = 10
#     matcher             = "200-499"
#   } 

# }

#  }
 
# resource "aws_lb_target_group_attachment" "tg_attachment_catalogue" {
#  target_group_arn = aws_lb_target_group.catalogue_tg.arn
#  target_id        = aws_lb.app-lb.id
#  port             = 8080
# }
