variable "name" {
  description = "Name to use for all resources created by this module"
  type = string
}

variable "image" {
  description = "Docker Image to run"
  type = string
}

variable "container_port" {
  description = "Port on which Image listens on"
  type = number
}

variable "replicas" {
  description = "No. of Replicas to run"
  type = number
}

variable "environment_variables" {
  description = "Env Variables to set for the app"
  type = map(string)
  default = {}
}