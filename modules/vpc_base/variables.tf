variable "cidr_block" {
	description = "The total ip space to be allocated for this VPC"
	#default = "10.0.0.0/24"
}
variable "owner" {
	description = "Ideally the name of the company which owns this vpc"
	#default = "AC3-madhav-wordpress-test"
}
variable "env" {
	description = "Define the type of environment this VPC belongs to: prod/staging/dev/perf/testing"
	#default = "dev"
}