output "alb_dns_name" {
  value = module.hello-world-app.alb_dns_name
  description = "DNS Name of the ALB"
}