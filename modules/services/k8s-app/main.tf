terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
    }
  }
}

locals {
  pod_labels = {
    app = var.name
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = var.name
  }
  spec {
    replicas = var.replicas
    template {
      metadata {
        labels = local.pod_labels
      }
      spec {
        container {
          name = var.name
          image = var.image
          port {
            container_port = var.container_port          
          }
          dynamic "env" {
            for_each = var.environment_variables
            content {
              name = env.key
              value = env.value
            }
          }
        }
      }
    }
    selector {
      match_labels = local.pod_labels
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = var.name
  }
  spec {
    type = "LoadBalancer"
    port {
      port = 80
      target_port = var.container_port
      protocol = "TCP"
    }
    selector = local.pod_labels
  }
}

