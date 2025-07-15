variable "name" {
  description = "Name to use for EKS Cluster"
  type = string
}

variable "min_size" {
  description = "Min No. of nodes in EKS"
  type = number
}

variable "max_size" {
  description = "Max No. of nodes in EKS"
  type = number
}

variable "desired_size" {
  description = "Desired No. of nodes in EKS"
  type = number
}

variable "instance_types" {
  description = "Types of EC2 instance to run in the node group"
  type = list(string)
}