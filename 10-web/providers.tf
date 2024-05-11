terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }
 backend "s3" {
    bucket = "eternal-s3-dev"
    key    = "web-pipeline"
    region = "us-east-1"
    dynamodb_table = "s3-table-dev"
    }


}
