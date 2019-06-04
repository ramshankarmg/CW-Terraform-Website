variable "owner" {
    description = "owner of this rds"
  
}

variable "env" {
    description = "env which this rds belongs to"
  
}

variable "app" {
    description = "which app this rds belongs to"
  
}


variable "vpc_id" {
  description = "VPC ID in which the security groups needs to be created"
}


variable "vpc_cidr_block" {
  description = "CIDR block allocated to the VPC"
}


variable "local_ip" {
  description = "this is local ip of the system from where terraform is run. This ensures only this machine has ssh access to the bastion host"
}
