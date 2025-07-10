provider "aws" {
region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terrr-state-file"
    key = "global/iam/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

data "aws_iam_policy_document" "cloudwatch-read-only" {
    statement {
        effect = "allow"
        actions = [ 
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*"
         ]
         resources = [ "*" ]
    }
}

resource "aws_iam_policy" "example" {
    name = "cloudwatch-read-only"
    policy = data.aws_iam_policy_document.cloudwatch-read-only.json
}

data "aws_iam_policy_document" "cloudwatch-full-access" {
    statement {
        effect = "allow"
        actions = [ "cloudwatch:*" ]
        resources = [ "*" ]
    }
}

resource "aws_iam_user" "neo" {
    name = "neo"
}

resource "aws_iam_policy" "cloudwatch-full-access" {
    name = "cloudwatch-full-access"
    policy = data.aws_iam_policy_document.cloudwatch-full-access.json
}

resource "aws_iam_user_policy_attachment" "neo-cloudwatch-full-access" {
    count = var.give_neo_cloudwatch_full_access ? 1 : 0
    user = aws_iam_user.neo.name
    policy_arn = aws_iam_policy.cloudwatch-full-access.arn
}

resource "aws_iam_user_policy_attachment" "neo-cloudwatch-read-only" {
    count = var.give_neo_cloudwatch_full_access ? 0 : 1
    user = aws_iam_user.neo.name
    policy_arn = aws_iam_policy.cloudwatch-read-only.arn
 
}
