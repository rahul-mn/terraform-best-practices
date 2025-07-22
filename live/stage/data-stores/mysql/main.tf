provider "aws" {
  region = "ap-south-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.1"
    }
  }
  backend "s3" {
  }  
}

module "mysql" {
  source = "../../../../modules/data-storage/mqsyl"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

