variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

module "test-ec2-nat" {
  source = "../../"

  project            = "module-test"
  environment        = "ec2-nat"
  availability_zones = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  vpc_cidr           = "10.10.0.0/16"
  private_subnets    = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets     = ["10.10.11.0/24", "10.10.12.0/24"]

  enable_nat_gateway  = "true"
  single_nat_gateway  = "true"
  nat_as_ec2_instance = "true"

  instance_type = "${var.instance_type}"
}

output "ec2_nat_ami" {
  value = "${module.test-ec2-nat.ec2_nat_ami}"
}
