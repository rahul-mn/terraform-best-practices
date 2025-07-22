output "alb_dns_name" {
    value = module.webserver_cluster.alb_dns_name
    description = "Domain name of the LB Server"
}

output "app_path" {
  description = "The path to the main page of the hello-world-app."
  value       = "/index.xhtml" # Or reference a variable if the path is configurable
}
