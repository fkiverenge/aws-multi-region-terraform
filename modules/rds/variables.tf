
variable "vpc_id" {
  description = "VPC Id where the RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDS for the RDS subnet group"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group of the application EC2 instances"
  type        = string
}

variable "db_name" {
  description = "Name of the initial Postgresql database "
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for Postgresql"
  type        = string
  default     = "dbadmin"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "RDS instance storage type"
  type        = string
  default     = "gp3"
}

variable "db_engine" {
  description = "The database engine used by the RDS instance"
  type        = string
  default     = "postgres"
}