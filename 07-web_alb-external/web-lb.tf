resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

  #enable_deletion_protection = true


  tags = merge(var.common_tags,
    { 
     Name = "${var.project}-${var.environment}-${var.tags.component}"
   } )
}
resource "aws_lb_listener" "web_alb_https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_ssm_parameter.eternaldomain_certificate_arn.value
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
resource "aws_route53_record" "web_alb_dns" {
  zone_id = var.zone_id
  name    = "web-${var.environment}"
  type    = "A" # OR "AAAA"

  alias {
      name                   = aws_lb.web_alb.dns_name
      zone_id                = aws_lb.web_alb.zone_id
      evaluate_target_health = true
  }
}
resource "aws_lb_listener_rule" "web_alb-rule" {
  listener_arn =  aws_lb_listener.web_alb_https.arn
  priority     = 1
  

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

  

  condition {
    host_header {
      values = ["web-${var.environment}.${var.zone_name}"]
    }
  }


 tags = merge(local.commontag,
    {
      Name             = "${local.name}-web_listner_rule"
      Create_date_time = local.time
  })

}

resource "aws_lb_target_group" "web_tg" { // Target Group web
 name     = "${var.project}-${var.environment}-web-tg"
 port     = 80
 protocol = "HTTP"
 vpc_id   = data.aws_ssm_parameter.vpc_id.value
 deregistration_delay = 60
 
 health_check {
    path                = "/health"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
    interval = 10
    
  } 

}