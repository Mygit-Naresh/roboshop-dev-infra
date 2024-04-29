module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "vpn"    

  instance_type          = "t2.micro"
  ami = data.aws_ami.centos.image_id
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = data.aws_subnet.default.id
  user_data = file("openvpn.sh")

  tags = merge(local.commontag, 
       { 
        Name = "${local.name}-openvpn_instance"
        Create_date_time = local.time
        lastupdate  = formatdate("DD-MMM-YY hh:mm:ss ZZZ", timestamp())
      })
    
  }