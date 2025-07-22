provider "aws" {
  region = "ap-south-1"
}

module "alb" {
  source = "../../modules/networking/alb"

  alb_name = var.alb_name
  server_port = 8080
  subnet_ids = data.aws_subnets.default.ids
}

