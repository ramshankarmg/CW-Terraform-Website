
variable "vpc_id" {
	description = "Add the vpc-id of the corresponding vpc to this internet gateway"
  
}

variable "cidr_block" {
  description = "Define the cidr block for this subnet"
}

variable "availability_zone" {
  description = "The AWS AZ in which this subnet needs to be created"
}


variable "map_public_ip_on_launch" {
	description = "true/false to decide whether public ip should be attached or not for machines launched in this subnet"
}


variable "name" {
	description = "Name to be given this subnet"
}
