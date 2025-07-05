provider "aws" {
region = "ap-south-1"
}
module "webserver_cluster" {
source = "../../../modules/services/webserver-cluster"
cluster_name = "cluster-stage"
db_remote_state_bucket = "terrr-state-file"
db_remote_state_key = "services/webserver-cluster/terraform.tfstate"
instance_type = "t2.micro"
min_size = 2
max_size = 10
}