locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  any_cidr = ["0.0.0.0/0"]
  tcp_protocol = "tcp"
}

resource "aws_security_group" "instance" {
    name = "${var.cluster_name}-instances"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = local.tcp_protocol
        cidr_blocks = local.any_cidr
    }
}

resource "aws_launch_template" "example" {
    image_id = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = var.user_data
    # user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    #     server_port = var.server_port
    #     db_address = data.terraform_remote_state.db.outputs.address
    #     db_port = data.terraform_remote_state.db.outputs.port
    #     server_text = var.server_text
    #     }))
}

resource "aws_autoscaling_group" "example" {
    name = var.cluster_name
    launch_template {
        id  = aws_launch_template.example.id
        version = "$Latest"
    }
    vpc_zone_identifier = var.subnet_ids
    target_group_arns = var.target_group_arn
    health_check_type = var.health_check_type
    min_size = var.min_size
    max_size = var.max_size

    instance_refresh {
        strategy = "Rolling"
        preferences {
          min_healthy_percentage = 50
        }
    }

    dynamic "tag" {
        for_each = {
        for key, value in var.custom_tags: key => upper(value) if key != "Name"
        }
        content {
            key = tag.key
            value = tag.value
            propagate_at_launch = true
        }
    }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    count = var.enable_autoscaling ? 1 : 0
    scheduled_action_name = "scale-out-during-business-hours"
    min_size = 2
    max_size = 10
    desired_capacity = 10
    recurrence = "0 9 * * *"
    autoscaling_group_name = aws_autoscaling_group.example.name

}
resource "aws_autoscaling_schedule" "scale_in_at_night" {
    count = var.enable_autoscaling ? 1 : 0
    scheduled_action_name = "scale-in-at-night"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"
    autoscaling_group_name = aws_autoscaling_group.example.name
}