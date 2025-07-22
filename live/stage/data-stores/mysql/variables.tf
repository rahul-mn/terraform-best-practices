variable "db_name" {
    description = "The name to use for the database"
    type = string
    default = "example_database_stage"
}

variable "db_username" {
    description = "The name to use for the database user"
    type = string
    sensitive = true

}

variable "db_password" {
    description = "The password to use for the database user"
    type = string
    sensitive = true
}