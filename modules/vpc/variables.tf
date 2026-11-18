variable "vpc_cidr" {
  description = "CIDR block used by the vpc"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "az_count" {
  description = "The number of availability zones to use"
  type        = number
  default     = 2
}