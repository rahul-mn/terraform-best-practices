locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  any_cidr = ["0.0.0.0/0"]
  tcp_protocol = "tcp"
}

resource "aws_lb" "example" {
    name = "${var.alb_name}-lb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb.id]
    subnets = var.subnet_ids
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.arn
    port = local.http_port
    protocol = "HTTP"

    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "404: Page not found"
            status_code = 404
        }
    }
}

resource "aws_security_group" "alb" {
    name = "${var.alb_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
    type = "ingress"
    from_port = local.http_port
    to_port = local.http_port
    protocol = local.tcp_protocol
    cidr_blocks = local.any_cidr

    security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type = "egress"
    security_group_id = aws_security_group.alb.id

    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.any_cidr
}