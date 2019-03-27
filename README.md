# AWS Core module

[![License](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](https://raw.githubusercontent.com/lean-delivery/tf-module-aws-core/master/LICENSE)
[![Build Status](https://travis-ci.org/lean-delivery/tf-module-aws-core.svg?branch=master)](https://travis-ci.org/lean-delivery/tf-module-aws-core)

## Description

Terraform module to setup AWS VPC with required parameters.
Based on Hashicorp's [VPC module](https://github.com/terraform-aws-modules/terraform-aws-vpc).

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [Route](https://www.terraform.io/docs/providers/aws/r/route.html)
* [Route table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html)
* [VPN Gateway](https://www.terraform.io/docs/providers/aws/r/vpn_gateway.html)
* [VPC Endpoint](https://www.terraform.io/docs/providers/aws/r/vpc_endpoint.html):
  * Gateway: S3, DynamoDB
  * Interface: EC2, SSM, EC2 Messages, SSM Messages, ECR API, ECR DKR, API Gateway
* [RDS DB Subnet Group](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)
* [ElastiCache Subnet Group](https://www.terraform.io/docs/providers/aws/r/elasticache_subnet_group.html)
* [Redshift Subnet Group](https://www.terraform.io/docs/providers/aws/r/redshift_subnet_group.html)
* [DHCP Options Set](https://www.terraform.io/docs/providers/aws/r/vpc_dhcp_options.html)
* [Default VPC](https://www.terraform.io/docs/providers/aws/r/default_vpc.html)

## Usage

### Conditional creation

```
module "core" {
  source = "github.com/lean-delivery/tf-module-awscore"

  project            = "Project"
  environment        = "dev"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr           = "10.0.0.0/16"
  private_subnets    = ["10.11.0.0/24", "10.11.1.0/24", "10.11.2.0/24"]
  public_subnets     = ["10.11.3.0/24", "10.11.4.0/24", "10.11.5.0/24"]

  enable_nat_gateway = "true"
}
```

### Examples

* [Simple VPC](https://github.com/lean-delivery/tf-module-aws-core/tree/master/examples/simple)
* [EC2 as custom NAT](https://github.com/lean-delivery/tf-module-aws-core/tree/master/examples/ec2-as-nat)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability\_zones | A list of availability zones in the region | list | `<list>` | no |
| create\_route53\_zone | Switch to create Route53 zone | string | `"false"` | no |
| enable\_dns\_hostnames | Should be true to enable DNS hostnames in the VPC | string | `"false"` | no |
| enable\_dns\_support | Should be true to enable DNS support in the VPC | string | `"true"` | no |
| enable\_nat\_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | string | `"false"` | no |
| environment | Environment name is used to identify resources | string | `"env"` | no |
| instance\_type | The type of instance to start | string | `"t3.nano"` | no |
| map\_public\_ip\_on\_launch | Should be false if you do not want to auto-assign public IP on launch | string | `"true"` | no |
| nat\_as\_ec2\_instance | Setup NAT as EC2 instance instead of service | string | `"false"` | no |
| private\_subnets | A list of private subnets inside the VPC | list | `<list>` | no |
| project | Project name is used to identify resources | string | `"project"` | no |
| public\_subnets | A list of public subnets inside the VPC | list | `<list>` | no |
| root\_domain | Name of Route53 zone (if 'create_route53_zone' = True) | string | `""` | no |
| single\_nat\_gateway | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | string | `"false"` | no |
| tags | Additional tags for resources | map | `<map>` | no |
| vpc\_cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | string | `"0.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| database\_route\_table\_ids | List of IDs of database route tables |
| database\_subnet\_group | ID of database subnet group |
| database\_subnets | List of IDs of database subnets |
| database\_subnets\_cidr\_blocks | List of cidr_blocks of database subnets |
| default\_network\_acl\_id | The ID of the default network ACL |
| default\_route\_table\_id | The ID of the default route table |
| default\_security\_group\_id | The ID of the security group created by default on VPC creation |
| default\_vpc\_cidr\_block | The CIDR block of the VPC |
| default\_vpc\_default\_network\_acl\_id | The ID of the default network ACL |
| default\_vpc\_default\_route\_table\_id | The ID of the default route table |
| default\_vpc\_default\_security\_group\_id | The ID of the security group created by default on VPC creation |
| default\_vpc\_enable\_dns\_hostnames | Whether or not the VPC has DNS hostname support |
| default\_vpc\_enable\_dns\_support | Whether or not the VPC has DNS support |
| default\_vpc\_id | The ID of the VPC |
| default\_vpc\_instance\_tenancy | Tenancy of instances spin up within VPC |
| default\_vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC |
| ec2\_nat\_ami | EC2 AMI used for NAT instances |
| elasticache\_route\_table\_ids | List of IDs of elasticache route tables |
| elasticache\_subnet\_group | ID of elasticache subnet group |
| elasticache\_subnet\_group\_name | Name of elasticache subnet group |
| elasticache\_subnets | List of IDs of elasticache subnets |
| elasticache\_subnets\_cidr\_blocks | List of cidr_blocks of elasticache subnets |
| environment | Evnironment name |
| igw\_id | The ID of the Internet Gateway |
| intra\_route\_table\_ids | List of IDs of intra route tables |
| intra\_subnets | List of IDs of intra subnets |
| intra\_subnets\_cidr\_blocks | List of cidr_blocks of intra subnets |
| nat\_ec2\_ids | List of NAT instance IDs |
| nat\_ids | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| nat\_public\_ips | List of public Elastic IPs created for AWS NAT Gateway |
| natgw\_ids | List of NAT Gateway IDs |
| private\_route\_table\_ids | List of IDs of private route tables |
| private\_subnets | List of IDs of private subnets |
| private\_subnets\_cidr\_blocks | List of cidr_blocks of private subnets |
| project | Project name |
| public\_route\_table\_ids | List of IDs of public route tables |
| public\_subnets | List of IDs of public subnets |
| public\_subnets\_cidr\_blocks | List of cidr_blocks of public subnets |
| redshift\_route\_table\_ids | List of IDs of redshift route tables |
| redshift\_subnet\_group | ID of redshift subnet group |
| redshift\_subnets | List of IDs of redshift subnets |
| redshift\_subnets\_cidr\_blocks | List of cidr_blocks of redshift subnets |
| route53\_zone\_id | The ID of created Route53 zone. |
| vgw\_id | The ID of the VPN Gateway |
| vpc\_cidr\_block | The CIDR block of the VPC |
| vpc\_enable\_dns\_hostnames | Whether or not the VPC has DNS hostname support |
| vpc\_enable\_dns\_support | Whether or not the VPC has DNS support |
| vpc\_endpoint\_dynamodb\_id | The ID of VPC endpoint for DynamoDB |
| vpc\_endpoint\_dynamodb\_pl\_id | The prefix list for the DynamoDB VPC endpoint. |
| vpc\_endpoint\_s3\_id | The ID of VPC endpoint for S3 |
| vpc\_endpoint\_s3\_pl\_id | The prefix list for the S3 VPC endpoint. |
| vpc\_id | The ID of the VPC |
| vpc\_instance\_tenancy | Tenancy of instances spin up within VPC |
| vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC |
| vpc\_secondary\_cidr\_blocks | List of secondary CIDR blocks of the VPC |

## Terraform versions

Terraform version 0.11.11 or newer is required for this module to work.

## Contributing

Thank you for your interest in contributing! Please refer to [CONTRIBUTING.md](https://github.com/lean-delivery/tf-module-aws-core/blob/master/CONTRIBUTING.md) for guidance.

## License

Apache2.0 Licensed. See [LICENSE](https://github.com/lean-delivery/tf-module-aws-core/tree/master/LICENSE) for full details.

## Authors

Lean Delivery Team <team@lean-delivery.com>
