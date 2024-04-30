 variable "cidr_block" {
  default = "192.168.0.0/16"
 }
 variable   "public_subnet" {
   default = ["192.168.1.0/24","192.168.2.0/24"]
 }
variable  "private_subnet" {
    default = ["192.168.11.0/24","192.168.12.0/24"]
   }
variable "db_subnet" {
   default = ["192.168.21.0/24","192.168.22.0/24"]
}
 variable   "environment"  {
    default = "dev"
 }
variable  "project" {
    default = "useterraform"
} 
