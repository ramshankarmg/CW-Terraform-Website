
variable "owner" {
	description = "Ideally the name of the company which owns this vpc"
}
variable "env" {
	description = "Define the type of environment this VPC belongs to: prod/staging/dev/perf/testing"
}

variable "vpc_id" {
	description = "Add the vpc-id of the corresponding vpc to this internet gateway"
  
}
