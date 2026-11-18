
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = {
    #aws_subnet.public[keys(local.public_subnets)[0]].id,
    #aws_subnet.public[keys(local.public_subnets)[1]].id
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value = {
    for key, subnet in aws_subnet.private :
    key => subnet.id
    #aws_subnet.private[keys(local.private_subnets)[0]].id,
    #aws_subnet.private[keys(local.private_subnets)[1]].id
  }
}

output "nat_gateway_id" {
  description = "IDs of the Nat gateway"
  value = {
    for key, nat in aws_nat_gateway.main :
    key => nat.id
  }
}

output "alb_security_group_id" {
  description = "ID of the alb security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}