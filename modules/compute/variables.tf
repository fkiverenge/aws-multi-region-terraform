
variable "ami_id" {
  description = "AMI ID used by the ec2 instance"
  type        = string
}

variable "instance_type" {
  description = "Ec instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_id" {
  description = "Security group ID for EC2 instance"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where the EC2 instances will run"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}