provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

module "teratest_vpc" {
  source                  = "../"
  create_route53_zone     = "${var.create_route53_zone}"
  project                 = "${var.project}"
  environment             = "${var.environment}"
  availability_zones      = "${var.availability_zones}"
  vpc_cidr                = "${var.vpc_cidr}"
  private_subnets         = "${var.private_subnets}"
  public_subnets          = "${var.public_subnets}"
  enable_nat_gateway      = "${var.enable_nat_gateway}"
  single_nat_gateway      = "${var.single_nat_gateway}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  tags                    = "${var.tags}"
  nat_as_ec2_instance     = "${var.nat_as_ec2_instance}"
  instance_type           = "${var.instance_type}"
  enable_dns_support      = "${var.enable_dns_support}"
  enable_dns_hostnames    = "${var.enable_dns_hostnames}"
  key_name                = "${var.key_name}"
}
