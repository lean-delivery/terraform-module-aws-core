variable "create_route53_zone" {
  default     = "false"
  description = "Switch to create Route53 zone"
}

variable "root_domain" {
  type        = "string"
  default     = ""
  description = "Name of Route53 zone (if 'create_route53_zone' = True)"
}

variable "project" {
  type        = "string"
  default     = "project"
  description = "Project name is used to identify resources"
}

variable "environment" {
  type        = "string"
  default     = "env"
  description = "Environment name is used to identify resources"
}

variable "availability_zones" {
  type        = "list"
  default     = []
  description = "A list of availability zones in the region"
}

variable "vpc_cidr" {
  default     = "0.0.0.0/16"
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
}

variable "private_subnets" {
  type        = "list"
  default     = []
  description = "A list of private subnets inside the VPC"
}

variable "public_subnets" {
  type        = "list"
  default     = []
  description = "A list of public subnets inside the VPC"
}

variable "enable_nat_gateway" {
  default     = "false"
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
}

variable "single_nat_gateway" {
  default     = "false"
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
}

variable "map_public_ip_on_launch" {
  default     = "true"
  description = "Should be false if you do not want to auto-assign public IP on launch"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags for resources"
}

variable "nat_as_ec2_instance" {
  description = "Setup NAT as EC2 instance instead of service"
  default     = "false"
}

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t3.nano"
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = "true"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = "false"
}

variable "database_subnets" {
  description = "A list of database subnets"
  default     = []
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets"
  default     = {}
}

variable "database_subnet_suffix" {
  description = "Suffix to append to database subnets name"
  default     = "db"
}

variable "create_database_subnet_group" {
  description = "Controls if database subnet group should be created"
  default     = true
}

variable "database_subnet_group_tags" {
  description = "Additional tags for the database subnet group"
  default     = {}
}

variable "public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets"
  default     = false
}

variable "private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets"
  default     = false
}

variable "database_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for database subnets"
  default     = false
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACLs"

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "database_inbound_acl_rules" {
  description = "Database subnets inbound network ACL rules"

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "database_outbound_acl_rules" {
  description = "Database subnets outbound network ACL rules"

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}
