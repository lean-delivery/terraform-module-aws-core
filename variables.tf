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

variable "region" {
  description = "AWS Region"
  default     = ""
}

variable "amis" {
  type        = "map"
  default     = {}
  description = "A map of AZs with AMIs ({<az> = <ami>})"
}

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t3.nano"
}