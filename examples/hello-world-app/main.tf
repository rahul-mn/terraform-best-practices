provider "aws" {
  region = "us-east-2"
}

module "hello-world-app" {
  source = "../../modules/services/hello-world-app"

  environment = var.environment
  server_port = 8080
  mysql_config = var.mysql_config

  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key = var.db_remote_state_key

  custom_tags = {
    Name = "hello-world-app"
    Environment = "stage"
    Owner = "dev-team"
    ManagedBy = "Terraform"
  }

  server_text = "Hello, World"
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  min_size = 1
  max_size = 1
  enable_autoscaling = false
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}