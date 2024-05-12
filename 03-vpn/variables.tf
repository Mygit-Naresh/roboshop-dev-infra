 variable   "environment"  {
    default = "dev"
 }
variable  "project" {
    default = "eternalplace"
} 
variable "common_tags" {
     type = map(string)
     default = {
        Createdby = "Terraform",
        Costcenter = "FIN-005-HYD-CLOUD-AWS",
        Admin_email = "admin.useterraform@gmail.com"
    }
}  