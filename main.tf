module "ireland" {
  source = "./modules/vpc"

  providers = {
    aws = aws
  }

  vpc_cidr = var.vpc_cidr
  vpc_name = "terraform-ireland-vpc"
}

#module "south_africa" {
# source = "./modules/vpc"

#providers = {
# aws = aws.south_africa
#}

#vpc_cidr = "10.20.0.0/16"
#vpc_name = "terraform-south-africa-vpc"
#}

module "ireland_alb" {
  source = "./modules/alb"

  providers = {
    aws = aws
  }

  vpc_id            = module.ireland.vpc_id
  public_subnet_ids = values(module.ireland.public_subnet_ids)
  security_group_id = module.ireland.alb_security_group_id
}

module "ireland_compute" {
  source = "./modules/compute"

  providers = {
    aws = aws
  }
  ami_id             = "ami-0b3ba1acb76a70451"
  security_group_id  = module.ireland.ec2_security_group_id
  private_subnet_ids = values(module.ireland.private_subnet_ids)

  target_group_arn = module.ireland_alb.target_group_arn
}


module "ireland_route53" {
  source = "./modules/route53"

  providers = {
    aws = aws
  }
  domain_name  = "kulanjaro.internal"
  vpc_id       = module.ireland.vpc_id
  alb_dns_name = module.ireland_alb.alb_dns_name
  alb_zone_id  = module.ireland_alb.alb_zone_id
}

module "ireland_rds" {
  source = "./modules/rds"

  providers = {
    aws = aws
  }

  vpc_id = module.ireland.vpc_id

  private_subnet_ids = values(module.ireland.private_subnet_ids)

  app_security_group_id = module.ireland.ec2_security_group_id
}
