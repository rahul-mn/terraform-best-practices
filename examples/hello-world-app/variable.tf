variable "mysql_config" {
  description = "Config for the MySQL DB"
  type = object({
    address = string
    port = number 
  })
  default = {
    address = "mock-addr"
    port = 12345
  }
}

variable "environment" {
  description = "Name of ENV we are deploying to"
  type = string
  default = "dev"
}

variable "db_remote_state_bucket" {
  description = "Name of S3 Bucket for DB remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "Key for DB remote state"
  type = string  
}