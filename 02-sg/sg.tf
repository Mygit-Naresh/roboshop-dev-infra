module "web_alb" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "web-alb"
  sg_description =  "security group created for web application loadbalancer"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "app-lb" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "app-lb"
  sg_description =  "security group created for application loadbalancer"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "mongodb" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "mongodb"
  sg_description =  var.sg_description
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 }
module "user" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "user"
  sg_description =  "security group created to attach user instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  

}
module "catalogue" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "catalogue"
  sg_description =  "security group created to attach catalogue instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

}
module "redis" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "redis"
  sg_description =  "security group created to attach redis instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

}
module "mysql" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "mysql"
  sg_description =  "security group created to attach mysql instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 
}
module "rabbitmq" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "rabbitmq"
  sg_description =  "security group created to attach rabbitmq instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  
}
module "payment" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "payment"
  sg_description =  "security group created to attach payment instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 
}
module "cart" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "cart"
  sg_description =  "security group created to attach cart instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 
}
module "shipping" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "shipping"
  sg_description =  "security group created to attach shipping instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  
}
module "ratings" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "ratings"
  sg_description =  "security group created to attach ratings instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  
}
module "web" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "web"
  sg_description =  "security group created to attach web instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

}
module "vpn" {
  source = "git::https://github.com/Mygit-Naresh/modules.git"
  environment = var.environment
  project = var.project
  sg_name =  "vpn"
  sg_description =  "security group created to attach web instances"
  vpc_id = data.aws_vpc.default.id
  
}

# INCOMING RULUES #App ALB should accept connections only from cart,shipping etc since it is internal(NOT NOT YET)

resource "aws_security_group_rule" "mongodb_in_catalogue" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from catalogue servers"
 from_port         = 27017
 to_port           = 27017
 protocol          = "tcp"
 security_group_id = module.mongodb.sg_id
 source_security_group_id = module.catalogue.sg_id
}
resource "aws_security_group_rule" "mongodb_in_user" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from user servers"
 from_port         = 27017
 to_port           = 27017
 protocol          = "tcp"
 security_group_id = module.mongodb.sg_id
 source_security_group_id = module.user.sg_id
}
resource "aws_security_group_rule" "redis_in_user" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from redis servers"
 from_port         = 6379
 to_port           = 6379
 protocol          = "tcp"
 security_group_id = module.redis.sg_id
 source_security_group_id = module.user.sg_id
}
resource "aws_security_group_rule" "redis_in_cart" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from cart servers"
 from_port         = 6379
 to_port           = 6379
 protocol          = "tcp"
 security_group_id = module.redis.sg_id
 source_security_group_id = module.cart.sg_id
}
resource "aws_security_group_rule" "mysql_in_shipping" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from catalogue servers"
 from_port         = 3306
 to_port           = 3306
 protocol          = "tcp"
 security_group_id = module.mysql.sg_id
 source_security_group_id = module.shipping.sg_id
 }
resource "aws_security_group_rule" "mysql_in_ratings" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from catalogue servers"
 from_port         = 3306
 to_port           = 3306
 protocol          = "tcp"
 security_group_id = module.mysql.sg_id
 source_security_group_id = module.ratings.sg_id
 }
resource "aws_security_group_rule" "rabbitmq_in_payment" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from catalogue servers"
 from_port         = 5672
 to_port           = 5672
 protocol          = "tcp"
 security_group_id = module.rabbitmq.sg_id
 source_security_group_id = module.payment.sg_id
 }
 resource "aws_security_group_rule" "rabbitmq_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.rabbitmq.sg_id
 source_security_group_id = module.vpn.sg_id
}
 ########## Allow ibound rule 22 from VPN source group ###########
resource "aws_security_group_rule" "mongodb_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.mongodb.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "redis_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.redis.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "mysql_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.mysql.sg_id
 source_security_group_id = module.vpn.sg_id
}

#catalogue
resource "aws_security_group_rule" "catalogue_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.catalogue.sg_id
 source_security_group_id = module.vpn.sg_id
}
#  resource "aws_security_group_rule" "catalogue_in_web" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.catalogue.sg_id
#  source_security_group_id = module.web.sg_id
#  }
# resource "aws_security_group_rule" "catalogue_in_cart" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.catalogue.sg_id
#  source_security_group_id = module.cart.sg_id
#  }
resource "aws_security_group_rule" "catalogue_in_app-lb" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 8080
 to_port           = 8080
 protocol          = "tcp"
 security_group_id = module.catalogue.sg_id
 source_security_group_id = module.app-lb.sg_id
 }

resource "aws_security_group_rule" "cart_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.cart.sg_id
 source_security_group_id = module.vpn.sg_id
 }
resource "aws_security_group_rule" "cart_in_app-lb" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 8080
 to_port           = 8080
 protocol          = "tcp"
 security_group_id = module.cart.sg_id
 source_security_group_id = module.app-lb.sg_id
}
# resource "aws_security_group_rule" "cart_in_web" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.cart.sg_id
#  source_security_group_id = module.web.sg_id
# }
# resource "aws_security_group_rule" "cart_in_shipping" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.cart.sg_id
#  source_security_group_id = module.shipping.sg_id
# }
# resource "aws_security_group_rule" "cart_in_payment" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.cart.sg_id
#  source_security_group_id = module.payment.sg_id
# }

resource "aws_security_group_rule" "user_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.user.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "user_in_app-lb" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 8080
 to_port           = 8080
 protocol          = "tcp"
 security_group_id = module.user.sg_id
 source_security_group_id = module.app-lb.sg_id
}
# resource "aws_security_group_rule" "user_in_payment" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.user.sg_id
#  source_security_group_id = module.payment.sg_id
# }
# resource "aws_security_group_rule" "user_in_web" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.user.sg_id
#  source_security_group_id = module.web.sg_id
# }


resource "aws_security_group_rule" "payment_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.payment.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "payment_in_app-lb" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 8080
 to_port           = 8080
 protocol          = "tcp"
 security_group_id = module.payment.sg_id
 source_security_group_id = module.app-lb.sg_id
}
# resource "aws_security_group_rule" "payment_in_web" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.payment.sg_id
#  source_security_group_id = module.web.sg_id
# }



resource "aws_security_group_rule" "shipping_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.shipping.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "shipping_in_app-lb" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 8080
 to_port           = 8080
 protocol          = "tcp"
 security_group_id = module.shipping.sg_id
 source_security_group_id = module.app-lb.sg_id
}

# resource "aws_security_group_rule" "shipping_in_web" {
#  type              = "ingress"
#  description       = "inbound rule for incoming traffic from vpn servers"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  security_group_id = module.shipping.sg_id
#  source_security_group_id = module.web.sg_id
# }
resource "aws_security_group_rule" "ratings_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.ratings.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "ratings_in_app-lb" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 8080
 to_port           = 8080
 protocol          = "tcp"
 security_group_id = module.ratings.sg_id
 source_security_group_id = module.app-lb.sg_id
}
resource "aws_security_group_rule" "web_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 security_group_id = module.web.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "web_in_home" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn servers"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 security_group_id = module.web.sg_id
 cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web_alb_in_home" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from catalogue servers"
 from_port         = 443
 to_port           = 443
 protocol          = "tcp"
 security_group_id = module.web_alb.sg_id
 cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "app-lb_in_vpn" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from vpn"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 security_group_id = module.app-lb.sg_id
 source_security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "app-lb_in_web" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from http"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 security_group_id = module.app-lb.sg_id
 source_security_group_id = module.web.sg_id
}
resource "aws_security_group_rule" "app-lb_in_cart" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from http"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 security_group_id = module.app-lb.sg_id
 source_security_group_id = module.cart.sg_id
}
resource "aws_security_group_rule" "app-lb_in_user" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from http"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 security_group_id = module.app-lb.sg_id
 source_security_group_id = module.user.sg_id
}
resource "aws_security_group_rule" "app-lb_in_payment" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from http"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 security_group_id = module.app-lb.sg_id
 source_security_group_id = module.payment.sg_id
}
resource "aws_security_group_rule" "app-lb_in_shipping" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from http"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 security_group_id = module.app-lb.sg_id
 source_security_group_id = module.shipping.sg_id
}
resource "aws_security_group_rule" "vpn_in_home" {
 type              = "ingress"
 description       = "inbound rule for incoming traffic from home"
 from_port         = 0
 to_port           = 65535
 protocol          = "tcp"
 security_group_id = module.vpn.sg_id
 cidr_blocks = ["0.0.0.0/0"]
 
}








