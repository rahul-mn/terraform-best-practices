provider "aws" {
region = "ap-south-1"
}
module "webserver_cluster" {
source = "../../../modules/services/webserver-cluster"
cluster_name = "cluster-prod"
db_remote_state_bucket = "terrr-state-file"
db_remote_state_key = "stage/data-stores/db/terraform.tfstate"
instance_type = "t3a.micro"
min_size = 2
max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    scheduled_action_name = "scale-out-during-business-hours"
    min_size = 2
    max_size = 10
    desired_capacity = 10
    recurrence = "0 9 * * *"
    autoscaling_group_name = module.webserver_cluster.asg_name
}
resource "aws_autoscaling_schedule" "scale_in_at_night" {
    scheduled_action_name = "scale-in-at-night"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"
    autoscaling_group_name = module.webserver_cluster.asg_name
}