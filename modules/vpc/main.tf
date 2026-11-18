terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_availability_zones" "my_zones" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = var.vpc_name
    }
  )
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "main-igw"
    }
  )
}


resource "aws_subnet" "public" {
  for_each          = local.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-${each.key}"
    }
  )
}

resource "aws_subnet" "private" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-${each.key}"
    }
  )
}

resource "aws_eip" "nat" {
  for_each = local.public_subnets
  domain   = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-${each.key}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "main" {
  for_each      = local.public_subnets
  allocation_id = aws_eip.nat[each.key].id
  #subnet_id     = aws_subnet.public[keys(local.public_subnets)[0]].id
  subnet_id = aws_subnet.public[each.key].id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-${each.key}-nat-gw"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-public-RT"
    }
  )
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_subnets
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}


resource "aws_route_table" "private" {
  for_each = local.private_subnets
  vpc_id   = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-${each.key}-private-RT"
    }
  )
}

resource "aws_route" "private" {
  for_each               = local.private_subnets
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.value.nat_key].id
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}


resource "aws_security_group" "alb" {
  description = "ALB security group"
  vpc_id      = aws_vpc.main.id
  name        = "${var.vpc_name}-alb-SG"

  ingress {
    description = "HTTP traffic from the Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS traffic from the Internet"
    to_port     = 443
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-alb-SG"
    }
  )
}

resource "aws_security_group" "ec2" {
  name        = "${var.vpc_name}-ec2-SG"
  description = "EC2 security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP Traffic from the alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vpc_name}-ec2-SG"
    }
  )
}

