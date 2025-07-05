locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  any_cidr = ["0.0.0.0/0"]
  tcp_protocol = "tcp"
}

terraform {
  backend "s3" {
    bucket = "terrr-state-file"
    key = "services/webserver-cluster/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

resource "aws_security_group" "instance" {
    name = "${var.cluster_name}-instances"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = local.any_protocol
        cidr_blocks = local.any_cidr
    }
}

resource "aws_launch_template" "example" {
    name_prefix = "example-"
    image_id = "ami-0f918f7e67a3323f0"
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = base64encode(templatefile("${path.module}/user-data.sh", {
        server_port = var.server_port
        db_address = data.terraform_remote_state.db.outputs.address
        db_port = data.terraform_remote_state.db.outputs.port
        }))
}

resource "aws_autoscaling_group" "example" {
    launch_template {
        id  = aws_launch_template.example.id
        version = "$Latest"
    }
    vpc_zone_identifier = data.aws_subnets.default.ids
    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"
    min_size = var.min_size
    max_size = var.max_size
    tag {
        key = "Name"
        value = "${var.cluster_name}-asg"
        propagate_at_launch = true
    }
}

resource "aws_lb" "example" {
    name = "${var.cluster_name}-lb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb.id]
    subnets = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "asg" {
    name = "${var.cluster_name}-lb-target-group"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
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

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority  = 100
    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}

resource "aws_security_group" "alb" {
    name = "${var.cluster_name}-alb"

    ingress {
        from_port = local.http_port
        to_port = local.http_port
        protocol = local.tcp_protocol
        cidr_blocks = local.any_cidr
    }
    egress {
        from_port = local.any_port
        to_port = local.any_port
        protocol = local.any_protocol
        cidr_blocks = local.any_cidr
    }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

data "terraform_remote_state" "db" {
    backend = "s3"

    config = {
        bucket = var.db_remote_state_bucket
        key = var.db_remote_state_key
        region = "us-east-1"
    }
}