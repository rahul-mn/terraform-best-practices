output "alb_dns_name" {
    value = module.alb.alb_dns_name
    description = "Domain name of the LB Server"
}

output "asg_name" {
    value = module.asg.asg_name
    description = "Name of the ASG"
}

output "alb_security_group_id" {
    value = module.asg.alb_security_group_id
    description = "ID of the ALB Security Group"
}