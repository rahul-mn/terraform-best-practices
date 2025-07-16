output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "DNS Name of the ALB"
}

output "alp_http_listener_arn" {
  value = aws_lb_listener.http.arn
  description = "ARN of the HTTP Listener"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "ID of the ALB Security Group"
}