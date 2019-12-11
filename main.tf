locals {
  default_tags = {
    Project     = var.project
    Environment = var.environment
  }

  ec2_nat_count = var.single_nat_gateway ? 1 : length(var.availability_zones)
}

resource "aws_route53_zone" "main" {
  count = var.create_route53_zone ? 1 : 0
  name  = var.root_domain

  tags = merge(local.default_tags, var.tags)
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
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  create_vpc = var.create_vpc

  name            = "${var.project}-${var.environment}"
  azs             = var.availability_zones
  cidr            = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  database_subnets       = var.database_subnets
  database_subnet_tags   = var.database_subnet_tags
  database_subnet_suffix = var.database_subnet_suffix

  create_database_subnet_group = var.create_database_subnet_group
  database_subnet_group_tags   = var.database_subnet_group_tags

  enable_nat_gateway      = var.enable_nat_gateway ? var.nat_as_ec2_instance ? "false" : "true" : "false"
  enable_vpn_gateway      = var.enable_vpn_gateway
  amazon_side_asn         = var.amazon_side_asn
  single_nat_gateway      = var.single_nat_gateway
  map_public_ip_on_launch = var.map_public_ip_on_launch // true by default

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  public_dedicated_network_acl   = var.public_dedicated_network_acl
  private_dedicated_network_acl  = var.private_dedicated_network_acl
  database_dedicated_network_acl = var.database_dedicated_network_acl

  public_inbound_acl_rules  = var.public_inbound_acl_rules
  public_outbound_acl_rules = var.public_outbound_acl_rules

  private_inbound_acl_rules  = var.private_inbound_acl_rules
  private_outbound_acl_rules = var.private_outbound_acl_rules

  database_inbound_acl_rules  = var.database_inbound_acl_rules
  database_outbound_acl_rules = var.database_outbound_acl_rules

  tags = merge(local.default_tags, var.tags)
}

resource "aws_default_security_group" "this" {
  count = var.create_vpc ? 1 : 0

  vpc_id = module.vpc.vpc_id

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

  tags = merge(
    local.default_tags,
    var.tags,
    {
      "Name" = "${var.project}-${var.environment}"
    },
  )
}

resource "aws_eip" "nat" {
  count    = var.create_vpc && var.enable_nat_gateway && var.nat_as_ec2_instance ? local.ec2_nat_count : 0
  instance = element(aws_instance.nat.*.id, count.index)
  vpc      = true
}

resource "aws_instance" "nat" {
  count = var.create_vpc && var.enable_nat_gateway && var.nat_as_ec2_instance ? local.ec2_nat_count : 0

  ami                    = data.aws_ami.nat.id
  instance_type          = var.instance_type
  availability_zone      = element(var.availability_zones, count.index)
  vpc_security_group_ids = aws_default_security_group.this[*].id
  subnet_id              = element(module.vpc.public_subnets, count.index)

  # ebs_block_device {
  #   device_name = "/dev/ebs1"

  #   volume_type = "gp2"

  #   # volume_size           = 100
  #   delete_on_termination = true

  #   encrypted = true
  # }

  tags = merge(
    local.default_tags,
    var.tags,
    {
      "Name" = "${var.project}-${var.environment}-${count.index}"
    },
  )
}

resource "aws_route" "private_nat_ec2" {
  count = var.create_vpc && var.enable_nat_gateway && var.nat_as_ec2_instance ? local.ec2_nat_count : 0

  route_table_id         = element(module.vpc.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = element(aws_instance.nat.*.id, count.index)

  timeouts {
    create = "5m"
  }
}
