# main.tf
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "frontend" {
  source = "./frontend"
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  load_balancer_dns = module.frontend.load_balancer_dns
}

module "backend" {
  source = "./backend"
  vpc_id = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
}

module "database" {
  source = "./database"
  vpc_id = module.vpc.vpc_id
}
