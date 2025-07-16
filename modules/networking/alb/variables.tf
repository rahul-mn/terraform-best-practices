variable "alb_name" {
  type = string
  description = "Name to use for ALB"
}

variable "server_port" {
    description = "The Port the server will use to server HTTP Requests"
    type = number
    default = 8080
}

variable "subnet_ids" {
  description = "Subnet ID in which to deploy"
  type = list(string)
  default = []
}