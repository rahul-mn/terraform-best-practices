output "primary_address" {
  value = module.mysql_primary.address
  description = "Connect to the primary database at this endpoint"
}

output "primary_port" {
  value = module.mysql_primary.port
  description = "The port the pimary database is listening on"
}

output "primary_arn" {
  value = module.mysql_primary.arn
  description = "ARN of Primary DB"
}

output "secondary_address" {
  value = module.mysql_replica.address
  description = "Connect to the secondary database at this endpoint"
}

output "secondary_port" {
  value = module.mysql_replica.port
  description = "The port the secondary database is listening on"
}

output "secondary_arn" {
  value = module.mysql_replica.arn
  description = "ARN of Replica DB"
}