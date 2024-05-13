variable "environment" {
  default = "dev"
}
variable "project" {
  default = "eternalplace"
}
variable "common_tags" {
  type = map(string)
  default = {
    Createdby   = "Terraform",
    Costcenter  = "FIN-005-HYD-CLOUD-AWS",
    Admin_email = "admin.useterraform@gmail.com"
  }
}
variable "zone_id" {
  default = "Z101265833JA5X90XBKK8"
 }
# variable "user" {
  
# }
# variable "password" {
   
# }
variable "network_interface_id" {
   default = "eni-07bd54cbdc0bc75e1"
}