# main.tf
provider "aws" {
  region = "us-east-1"
}

module "frontend" {
  source = "./frontend"
}

module "backend" {
  source = "./backend"
}

module "database" {
  source = "./database"
}
