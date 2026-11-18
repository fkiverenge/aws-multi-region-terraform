variable "vpc_id" {
  description = "VPC ID where the alb will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs where Alb will be deployed"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the alb"
  type        = string
}