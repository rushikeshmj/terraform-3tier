# outputs.tf
output "frontend_instance_ids" {
  description = "IDs of the frontend instances"
  value       = module.frontend.instance_ids
}

output "backend_instance_ids" {
  description = "IDs of the backend instances"
  value       = module.backend.instance_ids
}

output "database_endpoint" {
  description = "Endpoint of the database"
  value       = module.database.endpoint
}

output "frontend_load_balancer_dns" {
  description = "DNS name of the frontend load balancer"
  value       = module.frontend.load_balancer_dns
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}
