data "aws_caller_identity" "self" {}

data "aws_iam_policy_document" "cmk_admin_policy" {
  statement {
    effect = "Allow"
    actions = ["kms:*"]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [data.aws_caller_identity.self.account_id]
  }
}
}

resource "aws_kms_key" "cmk" {
  policy = data.aws_iam_policy_document.cmk_admin_policy.json
}

resource "aws_kms_alias" "cmk" {
  name = "alias/cmk-key-db"
  target_key_id = aws_kms_key.cmk.id
}

data "aws_kms_secrets" "creds" {
  secret {
    name = "db"
    payload = file("${path.module}/db-creds.yml.enc")
  }
}

locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-db"
  allocated_storage = 10
  instance_class = "db.t4g.micro"
  skip_final_snapshot = true

  backup_retention_period = var.backup_retention_days
  replicate_source_db = var.replicate_source_db

  engine = var.replicate_source_db == null ? "mysql" : null
  db_name = var.replicate_source_db == null ? var.db_name : null
  username    = var.replicate_source_db == null ? local.db_creds.username : null
  password_wo    = var.replicate_source_db == null ? local.db_creds.password : null
  password_wo_version = 1
}