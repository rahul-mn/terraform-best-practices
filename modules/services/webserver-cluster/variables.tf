variable "server_port" {
    description = "The Port the server will use to server HTTP Requests"
    type = number
    default = 8080
}

variable "cluster_name" {
    description = "Name for the Cluster"
    type = string
}

variable "db_remote_state_bucket" {
    description = "Name of the s3 Bucket for DB remote state"
    type = string
}

variable "db_remote_state_key" {
    description = "Path for the DB Remote state in S3"
    type = string
}

variable "instance_type" {
    description = "Type of EC2 Instance"
    type = string
    default = "t2.micro"
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

variable "server_text" {
    description = "Text the web server should return"
    type = string
    default = "Hello, World"
}
