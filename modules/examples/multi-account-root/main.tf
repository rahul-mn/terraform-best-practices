terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  alias = "parent"
}

provider "aws" {
  region = "ap-south-1"
  alias = "child"

  assume_role {
    role_arn = "arn:aws:iam::026024573432:role/OrganizationAccountAccessRole"
  }
}

data "aws_caller_identity" "parent" {
provider = aws.parent
}
data "aws_caller_identity" "child" {
provider = aws.child
}