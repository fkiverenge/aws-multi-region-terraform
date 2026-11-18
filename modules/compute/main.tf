
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_iam_role" "ec2_ssm" {
  name = "terraform-ec2-ssm-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "terraform-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}


resource "aws_launch_template" "app-template" {
  name_prefix   = "terraform-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-profile.name
  }

  vpc_security_group_ids = [
    var.security_group_id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    dnf update -y
    dnf install nginx -y

    systemctl enable nginx
    systemctl start nginx

    echo "<h1>Hello from EC2 instance</h1>" > /usr/share/nginx/html/index.html
    EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terraform-app"
    }
  }
}

resource "aws_autoscaling_group" "app-asg" {
  name             = "terraform-app-asg"
  min_size         = 2
  max_size         = 2
  desired_capacity = 2

  health_check_type = "EC2"

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {
    id      = aws_launch_template.app-template.id
    version = "$Latest"
  }
}