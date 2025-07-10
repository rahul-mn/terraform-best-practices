provider "aws" {
region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terrr-state-file"
    key = "prod/services/webserver-cluster/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"
  cluster_name = "cluster-prod"
  db_remote_state_bucket = "terrr-state-file"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
  enable_autoscaling = true

  custom_tags = {
    Owner = "prod-team"
    ManagedBy = "Terraform"
  }
}