provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terrr-state-file"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-db"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t4g.micro"
  skip_final_snapshot = true
  db_name = "exampledb"

  username = var.db_password
  password = var.db_password
}