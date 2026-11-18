variable "domain_name" {
  description = "Private DNS domain name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID associated with the private hosted zone"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the application load balancer"
  type        = string
}

variable "alb_zone_id" {
  description = "Canonical hosted zone id of the ALB"
  type        = string
}