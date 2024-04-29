variable "tags" {
  default = {
    service = "web"
  }
}
variable "common_tags" {
  type = map(string)
  default = {
    Createdby   = "Terraform",
    Costcenter  = "FIN-005-HYD-CLOUD-AWS",
    Admin_email = "admin.roboshop@gmail.com"
  }
}
variable "project" {
  default = "roboshop"
}
variable "environment" {
  default = "dev"
}
variable "zone_id" {
  default = "Z101265833JA5X90XBKK8"
}
variable "zone_name" {
  default = "eternaltrainings.online"  
}
variable "instance_type" {
  default = "t2.micro" 
}

variable "priority" {
  default = "20" 
}
variable "name" {
  default = "web"
}