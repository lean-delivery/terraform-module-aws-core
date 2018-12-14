locals {
  default_tags = {
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_route53_zone" "main" {
  count = "${ var.create_route53_zone ? 1 : 0 }"
  name  = "${var.root_domain}"

  tags = "${merge(local.default_tags, var.tags)}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "${var.project}-${var.environment}"
  azs             = "${var.availability_zones}"
  cidr            = "${var.vpc_cidr}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway      = "${var.enable_nat_gateway}"      //true
  single_nat_gateway      = "${var.single_nat_gateway}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}" // true by default

  tags = "${merge(local.default_tags, var.tags)}"
}

resource "aws_default_security_group" "assign-name" {
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(local.default_tags, var.tags, map("Name", "${var.project}-${var.environment}"))}"
}
