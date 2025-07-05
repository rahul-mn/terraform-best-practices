provider "aws" {
region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terrr-state-file"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

module "webserver_cluster" {
source = "../../../modules/services/webserver-cluster"
cluster_name = "cluster-stage"
db_remote_state_bucket = "terrr-state-file"
db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
instance_type = "t2.micro"
min_size = 2
max_size = 2
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.webserver_cluster.alb_security_group_id
}