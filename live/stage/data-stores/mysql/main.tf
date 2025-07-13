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
    bucket = "terrr-state-file"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }  
}

module "mysql" {
  source = "../../../../modules/data-storage/mqsyl"

  db_name = "prod_db"
  backup_retention_days = 1
}

