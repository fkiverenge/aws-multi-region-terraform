
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


resource "aws_route53_zone" "private" {
  name = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name        = "terraform-private-zone"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}