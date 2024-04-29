locals { 
   name = "${var.project}-${var.environment}"
   time  = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
}
locals {
   commontag  = var.common_tags
}


