data "aws_vpc"  "default" {
    default = true
}
data "aws_subnet"  "default" {
   vpc_id = data.aws_vpc.default.id
   availability_zone = "us-east-1a"
}
# output "defaultvpc" {
#     value = data.aws_vpc.default.id
# }

data "aws_security_group" "vpnsg" {
     filter { 
        name   = "tag:Name"
        values = ["VPN_SG"]
     }
}

# output "VPN_SG_out" {
#     value = data.aws_security_group.vpnsg.id
# }

# output "out_subnet" {
#     value = data.aws_subnet.default.id
# }

data "aws_ami" "centos" {
most_recent      = true
owners           = ["973714476881"]
  filter {
    name   = "name"
    values = ["Centos-8-*"]
  }
 }
#   output "amiid" {
#     value = data.aws_ami.centos.image_id
# }
data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project}/${var.environment}/vpn_sg_id"
}
