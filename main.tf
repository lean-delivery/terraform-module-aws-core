locals {
  default_tags = {
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }

  ec2_nat_count = "${ var.single_nat_gateway ? 1 : length(var.availability_zones) }"
}

resource "aws_route53_zone" "main" {
  count = "${ var.create_route53_zone ? 1 : 0 }"
  name  = "${var.root_domain}"

  tags = "${merge(local.default_tags, var.tags)}"
}

data "aws_ami" "nat" {
  # executable_users = ["self"]
  most_recent = true
  owners      = ["amazon"]

  # https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "${var.project}-${var.environment}"
  azs             = "${var.availability_zones}"
  cidr            = "${var.vpc_cidr}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway      = "${ var.enable_nat_gateway ? "${ var.nat_as_ec2_instance ? "false" : "true" }" : "false" }"
  single_nat_gateway      = "${var.single_nat_gateway}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"                                                            // true by default

  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

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
  count    = "${ var.enable_nat_gateway && var.nat_as_ec2_instance ? local.ec2_nat_count : 0 }"
  instance = "${element(aws_instance.nat.*.id, count.index)}"
  vpc      = true
}

resource "aws_key_pair" "tf_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "nat" {
  count = "${ var.enable_nat_gateway && var.nat_as_ec2_instance ? local.ec2_nat_count : 0 }"

  ami                    = "${data.aws_ami.nat.id}"
  instance_type          = "${var.instance_type}"
  availability_zone      = "${element(var.availability_zones, count.index)}"
  key_name               = "${aws_key_pair.tf_auth.id}"
  source_dest_check      = false
  vpc_security_group_ids = ["${aws_default_security_group.assign-name.id}"]
  subnet_id              = "${element(module.vpc.public_subnets, count.index)}"

  # ebs_block_device {
  #   device_name = "/dev/ebs1"


  #   volume_type = "gp2"


  #   # volume_size           = 100
  #   delete_on_termination = true


  #   encrypted = true
  # }

  tags = "${merge(local.default_tags, var.tags, map("Name", "${var.project}-${var.environment}-${count.index}"))}"
}

resource "aws_route" "private_nat_ec2" {
  count = "${ var.enable_nat_gateway && var.nat_as_ec2_instance ? local.ec2_nat_count : 0 }"

  route_table_id         = "${element(module.vpc.private_route_table_ids, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${element(aws_instance.nat.*.id, count.index)}"

  timeouts {
    create = "5m"
  }
}
