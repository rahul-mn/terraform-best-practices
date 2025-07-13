provider "aws" {
  region = "ap-south-1"
  alias = "primary"
}

provider "aws" {
  region = "us-east-1"
  alias = "replica" 
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
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

module "mysql_primary" {
  source = "../../../../modules/data-storage/mqsyl"

  providers = {
    aws = aws.primary
  }
  db_name = "prod_db"

  backup_retention_days = 1
}

module "mysql_replica" {

  providers = {
    aws = aws.replica
  }

  source = "../../../../modules/data-storage/mqsyl"

  replicate_source_db = module.mysql_primary.arn
}