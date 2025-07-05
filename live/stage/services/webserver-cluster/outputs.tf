output "alb_dns_name" {
    value = module.webserver_cluster.alb_dns_name
    description = "Domain name of the LB Server"
}