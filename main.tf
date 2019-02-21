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

resource "aws_eip" "nat" {
  count     = "${ var.enable_nat_gateway ? 0 : length(var.availability_zones) }"
  instance  = "${element(aws_instance.nat.*.id, count.index)}"
  vpc       = true
}

resource "aws_instance" "nat" {
  count = "${ var.enable_nat_gateway ? 0 : length(var.availability_zones) }"
  
  ami                     = "${lookup(var.amis, var.region)}"
  instance_type           = "${var.instance_type}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  vpc_security_group_ids  = ["${aws_default_security_group.assign-name.id}"]
  subnet_id               = "${element(module.vpc.public_subnets, count.index)}"
  
  tags = "${merge(local.default_tags, var.tags)}"
}

resource "aws_route" "private_nat_ec2" {
  count = "${ var.enable_nat_gateway ? 0 : length(var.availability_zones) }"

  route_table_id          = "${element(module.vpc.private_route_table_ids, count.index)}"
  destination_cidr_block  = "0.0.0.0/0"
  instance_id             = "${element(aws_instance.nat.*.id, count.index)}"

  timeouts {
    create = "5m"
  }
}