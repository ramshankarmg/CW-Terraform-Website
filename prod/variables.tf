#AWS variables
variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}

variable "region" {
  type = "string"
}

#TAGS
variable "env" {
  default = "demo"
  type    = "string"
}

variable "owner" {
  default = "owner"
  type    = "string"
}

variable "app" {
  default = "app"
  type    = "string"
}


# DATABASE Details
variable "db_dbname" {
  default = "test"
  type    = "string"
}

#RDS

variable "rds_instance_type" {
  description = "the size of the rds instance to be used"
  type = "string"
}

variable "rds_allocated_storage" {
  description = "what should be the size of the rds database"
  type = "string"

}

variable "rds_engine_type" {
  description = "mysql/aurora/postgres"
  type = "string"

}

variable "rds_engine_version" {
  description = "version of engine to be used with mysql"
  type = "string"

}

variable "rds_multi_az" {
  description = "should multi-az be enabled. Done normally only for prod"
  type = "string"

}


#APP
variable "aws_image_id" {
  description = "give a base image id to be used for installation"
  type = "string"
}

variable "ec2_instance_type" {
  description = "type of instance to be used for this environment"
  type = "string"
}

#ASG

variable "asg_min_size" {
  description = "minimum size to be maintained by the ASG group"
  type = "string"
}

variable "asg_max_size" {
  description = "maximum size the ASG is allowed to grow"
  type = "string"
}