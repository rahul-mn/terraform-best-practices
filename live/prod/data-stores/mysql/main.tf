provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terrr-state-file"
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

data "aws_secretsmanager_random_password" "test" {
  password_length = 20
}

resource "aws_secretsmanager_secret" "db_secrets" {
  name = "db-secrets"
  description = "Password of DB"
}

resource "aws_secretsmanager_secret_version" "db_secrets_version" {
  secret_id = aws_secretsmanager_secret.db_secrets.id
  secret_string = data.aws_secretsmanager_random_password.test.result
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-db"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t4g.micro"
  skip_final_snapshot = true
  db_name = "exampledb"

  username = var.db_password
  password_wo = aws_secretsmanager_secret_version.db_secrets_version.secret_string
  password_wo_version = 1
}