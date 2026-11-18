
locals {
  common_tags = {
    Project     = "terraform-aws-lab"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }

  #public_subnets = {
  # public_a = {
  #  cidr = cidrsubnet(var.vpc_cidr, 8, 1)
  #}
  #public_b = {
  # cidr = cidrsubnet(var.vpc_cidr, 8, 2)
  #}
  #}

  public_subnets = {
    for index, az in local.selected_azs :
    "public_${index + 1}" => {
      az   = az
      cidr = cidrsubnet(var.vpc_cidr, 8, index + 1)
    }
  }

  #private_subnets = {
  # private_a = {
  #  cidr = cidrsubnet(var.vpc_cidr, 8, 11)
  #}
  #private_b = {
  # cidr = cidrsubnet(var.vpc_cidr, 8, 12)
  #}
  #}

  private_subnets = {
    for index, az in local.selected_azs :
    "private_${index + 1}" => {
      az      = az
      cidr    = cidrsubnet(var.vpc_cidr, 8, index + 11)
      nat_key = "public_${index + 1}"
    }
  }

  selected_azs = slice(
    data.aws_availability_zones.my_zones.names,
    0,
    var.az_count
  )

}
