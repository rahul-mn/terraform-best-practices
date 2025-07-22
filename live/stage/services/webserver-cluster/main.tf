provider "aws" {
region = "ap-south-1"
}

# terraform {
#   backend "s3" {
#     bucket = "terrr-state-file"
#     key = var.db_remote_state_key
#     region = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt = true
#   }
# }

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"
  server_text = "Test Cluster"
  ami = "ami-0f918f7e67a3323f0"
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key = var.db_remote_state_key
  instance_type = "t3.micro"
  min_size = 1
  max_size = 1
  enable_autoscaling = false
  environment = var.environment

  custom_tags = {
    Name = "webserver-cluster"
    Environment = "stage"
    Owner = "dev-team"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.webserver_cluster.instance_security_group_id
}