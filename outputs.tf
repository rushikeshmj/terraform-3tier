# outputs.tf
output "frontend_instance_id" {
  description = "ID of the frontend instance"
  value       = module.frontend.instance_id
}

output "backend_instance_id" {
  description = "ID of the backend instance"
  value       = module.backend.instance_id
}

output "database_endpoint" {
  description = "Endpoint of the database"
  value       = module.database.endpoint
}
