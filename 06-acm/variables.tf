variable "environment" {
  default = "dev"
}
variable "project" {
  default = "useterraform"
}
variable "common_tags" {
  type = map(string)
  default = {
    Createdby   = "Terraform",
    Costcenter  = "FIN-005-HYD-CLOUD-AWS",
    Admin_email = "admin.useterraform@gmail.com"
  }
}
variable "tags" {
  default = {
    component = "catalogue"
  }  
}
variable "zone_id" {
  default = "Z101265833JA5X90XBKK8"
}
variable "domain_name" {
  default = "eternaltrainings.online"
}
