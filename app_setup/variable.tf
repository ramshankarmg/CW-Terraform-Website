#TAG VARIABLES
variable "owner" {
    description = "owner of this rds"
  
}

variable "env" {
    description = "env which this rds belongs to"
  
}

variable "app" {
    description = "which app this rds belongs to"
  
}

#INFRA VARIABLES
variable "public_subnet_a_id" {
  description = "id of the public subnet in A zone"
}

variable "public_subnet_b_id" {
  description = "id of the public subnet in B zone"
}

variable "private_subnet_a_id" {
  description = "id of the private subnet in A zone"
}

variable "private_subnet_b_id" {
  description = "id of the private subnet in B zone"
}

variable "key_name" {
  description = "name of the ssh key"
}


variable "instance_type" {
  description = "The type of instance to be used with EC2"
}

variable "ec2_sg_id" {
  description = "Security group pertaining to the EC2 instances"  
}

variable "elb_sg_id" {
  description = "Security groupt pertaining to the ELB"
}


variable "aws_image_id" {
  description = "The AMI to be used with the EC2 instance"
}


#AUTO-SCALING VARIABLES
variable "asg_min_size" {
  description = "the minimum number of instances to be launched in the ASG"
}

variable "asg_max_size" {
  description = "the maximum number of instances to be launched in the ASG"
}


#RDS VARIABLES
variable "rds_host" {
  description = "rds endpoint for installing the wordpress db"
}

variable "rds_username" {
  description = "rds username to connect to the database"
}

variable "rds_password" {
  description = "rds password to connect to the database"
}


#DATABASE DETAILS
variable "db_dbname" {
  description = "database name to be used for this app"
}
