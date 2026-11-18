
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_db_subnet_group" "postgress" {
  name       = "terraform-postgress-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "terraform-postgress-subnet-group"
    Environment = "learning"
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "postgress" {
  description = "Security group for Postgresql RDS"
  name        = "terraform-postgress-SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Connection from app servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    description = "Allow outbound traffic"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "terraform-postgress-SG"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_db_instance" "postgress" {
  identifier        = "terraform-postgress-instance"
  engine            = var.db_engine
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type

  db_name  = var.db_name
  username = var.db_username

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.postgress.name
  vpc_security_group_ids = [aws_security_group.postgress.id]

  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 1

  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name        = "terraform-postgress-instance"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

