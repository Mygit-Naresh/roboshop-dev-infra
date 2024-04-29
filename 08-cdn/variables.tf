variable "environment" {
  default = "dev"
}
variable "project" {
  default = "roboshop"
}
variable "common_tags" {
  type = map(string)
  default = {
    Createdby   = "Terraform",
    Costcenter  = "FIN-005-HYD-CLOUD-AWS",
    Admin_email = "admin.roboshop@gmail.com"
  }
}
variable "tags" {
  default = {
    component = "cloudfront"
  }  
}
variable "zone_id" {
  default = "Z101265833JA5X90XBKK8"
}
variable "zone_name" {
  default = "eternaltrainings.online"
}
