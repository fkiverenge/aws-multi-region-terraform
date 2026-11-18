

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_lb" "app-lb" {
  name               = "terraform-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]

  subnets = var.public_subnet_ids

  tags = {
    Name = "terraform-app-alb"
  }
}

resource "aws_lb_target_group" "app-tg" {
  name     = "terraform-app-tg"
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "terraform-app-tg"
  }
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.app-lb.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}