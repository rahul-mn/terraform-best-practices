variable "db_name" {
description = "Name for the DB."
type = string
default = null
}
# variable "db_username" {
# description = "Username for the DB."
# type = string
# sensitive = true
# default = null
# }
# variable "db_password" {
# description = "Password for the DB."
# type = string
# sensitive = true
# default = null
# }

variable "backup_retention_days" {
    description = "Days to Retain Backups. Must be greater than 0 to enable replication."
    type = number
    default = null
}

variable "replicate_source_db" {
  description = "Replicate the RDS at the given ARN"
  type = string
  default = null
}