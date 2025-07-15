output "service_endpoint" {
  value = module.simple_webapp.service_endpoint
  description = "K8s service endpoint"
}