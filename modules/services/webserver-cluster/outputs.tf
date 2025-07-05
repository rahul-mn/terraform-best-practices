output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "Domain name of the LB Server"
}

output "asg_name" {
    value = aws_autoscaling_group.example.name
    description = "Name of the ASG"
}