locals {
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets
}

data "aws_availability_zones" "available" {
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "5.13.0"
  name               = "devops-dashboard-vpc"
  cidr               = "10.0.0.0/16"
  azs                = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets    = ["10.0.0.0/20", "10.0.16.0/20"]
  public_subnets     = ["10.0.250.0/24", "10.0.251.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}