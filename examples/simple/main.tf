module "core" {
  source = "../../"

  project            = "Project"
  environment        = "dev"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr           = "10.0.0.0/16"
  private_subnets    = ["10.11.0.0/24", "10.11.1.0/24", "10.11.2.0/24"]
  public_subnets     = ["10.11.3.0/24", "10.11.4.0/24", "10.11.5.0/24"]

  enable_nat_gateway = "true"
}
