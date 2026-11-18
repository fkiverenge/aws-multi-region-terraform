

output "db_instance_id" {
  description = "RDS database instance ID"
  value       = aws_db_instance.postgress.id
}

output "db_endpoint" {
  description = "RDS Postgresql Endpoint"
  value       = aws_db_instance.postgress.endpoint
}

output "db_address" {
  description = "RDS Postgresql hostname"
  value       = aws_db_instance.postgress.address
}

output "db_port" {
  description = "RDS Postgresql port"
  value       = aws_db_instance.postgress.port
}

output "db_name" {
  description = "Initial Postgresql database name"
  value       = aws_db_instance.postgress.db_name
}

output "db_security_group_id" {
  description = "Security group ID attached to the RDS instance"
  value       = aws_security_group.postgress.id
}

output "master_user_secret_arn" {
  description = "ARN of the secrets manager secret containing the RDS master credentials"
  value       = aws_db_instance.postgress.master_user_secret[0].secret_arn
}