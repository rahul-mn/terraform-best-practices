variable "environment" {
  description = "Name of ENV we are deploying to"
  type = string
  default = "dev"
}

variable "db_remote_state_bucket" {
  description = "Name of S3 Bucket for DB remote state"
  type = string
  default = "terrr-state-file"
}

variable "db_remote_state_key" {
  description = "Key for DB remote state"
  type = string
  default = "test/test/terraform.tfstate"
}