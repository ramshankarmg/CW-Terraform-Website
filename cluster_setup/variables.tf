# variable "aws_region" {
#     description = "The region in which the AWS cluster needs to be launched"
#     default = "ap-southeast-1"
  
# }
variable "vpc_cidr_block" {
	description = "The total ip space to be allocated for this VPC"
	default = "10.0.0.0/16"
}
variable "owner" {
	description = "Ideally the name of the company which owns this vpc"
	default = "madhav-wordpress-test"
}
variable "env" {
	description = "Define the type of environment this VPC belongs to: prod/staging/dev/perf/testing"
	default = "test"
}

variable "public_cidr_route" {
  description = "Define the outgoing cidr block for the public route table"
  default = "0.0.0.0/0"
}

variable "private_cidr_route" {
  description = "Define the outgoing cidr block for the private route table"
  default = "0.0.0.0/0"
}
variable "subnet_1_public_cidr_block" {
  description = "cidr block to be assigned for this subnet "
  default = "10.0.1.0/24"
}

variable "subnet_2_public_cidr_block" {
  description = "cidr block to be assigned for this subnet"
  default = "10.0.2.0/24"
}

variable "subnet_1_private_cidr_block" {
  description = "cidr block that should be assigned to this subnet"
  default = "10.0.3.0/24"
  
}

variable "subnet_2_private_cidr_block" {
  description = "cidr block thatt should be assigned to this subnet"
  default = "10.0.4.0/24"
  
}

variable "subnet_1_az" {
  description = "The AZ in which this subnet will be located"
  default = "ap-southeast-1a"
}

variable "subnet_2_az" {
  description = "the AZ in which this subnet will be located"
  default = "ap-southeast-1b"
  
}


variable "map_public_ip_on_launch_in_public_subnet" {
  description  = "true/false to decide on automatic public ip address allocation to resources"
  default = "true"
  
}

variable "map_public_ip_on_launch_in_private_subnet" {
  description  = "true/false to decide on automatic public ip address allocation to resources"
  default = "false"
  
}