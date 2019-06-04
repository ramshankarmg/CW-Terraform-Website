variable "owner" {
    description = "owner of this rds"
  
}

variable "env" {
    description = "env which this rds belongs to"
  
}

variable "app" {
    description = "which app this rds belongs to"
  
}

variable rds_sg_id {
    description = "Security group to be assigned for this rds"

}
variable rds_subnet_id {
    description = "subnet to which this rds should belong to"
}

variable rds_master_password {
    description = "If you need a description for this , you are in the wrong place :D"
}

variable rds_engine_type {
    description = "The type of rds engine to be used"
    default = "mysql"
}
variable rds_engine_version {
    description = "The rds engine version"
    default = "5.6.34"
}
variable rds_backup_retention_period {
    description = "how long the backups need to be kept"
    default = "7"
}
variable rds_port {
    description = "Port on which mysql should be listening to"
    default = "3306"
}
variable rds_publicly_accessible {
    description = "Should the rds be publicly accisble. This should be no but for dev sometimes we might require it"
    default = "false"
}
variable rds_auto_minor_version_upgrade {
    description = "Minor versions normally have security updates and dont break systems.Should be enabled"
    default = "true"
}
variable rds_allow_major_version_upgrade {
    description = "Major version upgrades can break existing system.Shoudl be off for prod"
    default = "false"
}

variable rds_allocated_storage {
    description = "How much space should be allocated to this rds instance in GB"
    default = "50"
}
variable rds_instance_type {
    description = "Type of rds instance to be used"
    default = "db.t2.small"
}
variable rds_storage_type {
    description = "disk type ssd/gp2/iops,etc"
    default = "gp2"
}
variable rds_master_username {
    description = "username that will have admin privileges to connect to this rds"
    default = "admin"
}

variable rds_iops {
    description = "How much iops should this rds disk have"
    default = "0"
}
variable rds_multi_az {
    description = "Good to have it enabled on prod systems for failover and HA"
    default = "true"
}

# variable rds_snapshot_identifier {
#     description = "unique name by which the rds snapshot can be identified"
#     default = "wordpress-rds"
# }