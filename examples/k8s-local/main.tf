provider "kubernetes" {
  config_context = "docker-desktop"
  config_path = "~/.kube/config"
}

module "k8s-app" {
  source = "../../modules/services/k8s-app"

  name = "simple-webapp"
  image = "training/webapp"
  replicas = 2
  container_port = 5000

}