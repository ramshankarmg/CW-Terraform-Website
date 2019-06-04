
variable "vpc_id" {
	description = "Add the vpc-id of the corresponding vpc to this internet gateway"
  
}

variable "gateway_id" {
    description = "Internet gateway id for mapping to the routetable"
}

variable "owner" {
	description = "Ideally the name of the company which owns this vpc"
}
variable "env" {
	description = "Define the type of environment this VPC belongs to: prod/staging/dev/perf/testing"
}

variable "public_cidr_route" {
  description = "Define the outgoing cidr block for the public route table"
}