provider "aws" {
  region = "ap-south-1"
}

module "eks-cluster" {
  source = "../../modules/services/eks-cluster"
  name = "example-eks-cluster"
  min_size = 1
  max_size = 2
  desired_size = 1
  instance_types = [ "t2.medium" ]
}

provider "kubernetes" {
  host = module.eks-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.cluster_certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_name
}

module "simple_webapp" {
  source = "../../modules/services/k8s-app"
  name = "simple-webapp"
  image = "training/webapp"
  replicas = 2
  container_port = 5000

  environment_variables = {
    PROVIDER = "Terraform"
  }

  depends_on = [ module.eks-cluster ]

}