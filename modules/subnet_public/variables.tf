
variable "name" {
	description = "name of this subnet"
}

variable "cidr_block" {
	description = "The total ip space to be allocated for this subnet"
}


variable "vpc_id" {
	description = "Add the vpc-id of the corresponding vpc to this internet gateway"
  
}

variable "availability_zone" {
  description = "The availability zone this subnet should belong to"
}

variable "map_public_ip_on_launch" {
    description = "true/false value to decide if public ip address should be attached to resources in this subnet"
  
}

# variable "subnet_id" {
#   description = "this is the subnet id of this resource. We need this for route_table association"
# }

variable "route_table_id" {
  description = "the public route table id which needs to be attached to this subnet"
}

