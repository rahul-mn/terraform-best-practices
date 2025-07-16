variable "server_port" {
    description = "The Port the server will use to server HTTP Requests"
    type = number
    default = 8080
}

variable "server_text" {
    description = "Text the web server should return"
    type = string
    default = "Hello, World"
}

variable "cluster_name" {
    description = "Name for the Cluster"
    type = string
}

variable "instance_type" {
    description = "Type of EC2 Instance"
    type = string
    default = "t2.micro"
    validation {
      condition = contains(["t2.micro", "t3.micro"], var.instance_type)
      error_message = "Only free tier Instances are allowed: t2.micro | t3.micro."
    }
}

variable "min_size" {
  description = "Minimum Number of EC2 Instances in ASG"
  type = number
  default = 2
}

variable "max_size" {
  description = "Maximum Number of EC2 Instances in ASG"
  type = number
  default = 10
}

variable "custom_tags" {
    type = map(string)
    description = "Custom Tags for the Instances of ASG"
    default = {}
}

variable "enable_autoscaling" {
    type = bool
    description = "value to enable or disable autoscaling"
}

variable "ami" {
    description = "AMI ID to run the cluster with"
    type = string
    default = "ami-0f918f7e67a3323f0"
}

variable "subnet_ids" {
    description = "Subnet IDs to deploy to"
    type = list(string)
    default = []
}

variable "target_group_arn" {
  description = "ARN of ELB Target Group in which to register instances"
  type = list(string)
  default = []
}

variable "health_check_type" {
  description = "Type of Health Check to perform. Must be one of: EC2, ELB"
  type = string
  default = "EC2"
}

variable "user_data" {
  description = "User Data Script to run on each instance on boot"
  type = string
  default = null
}