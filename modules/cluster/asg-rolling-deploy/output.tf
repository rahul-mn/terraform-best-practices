output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "Name of the ASG"
}

output "instance_security_group_id" {
  value = aws_security_group.instance.id
  description = "ID of the Instance Security Group"
}