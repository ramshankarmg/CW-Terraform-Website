#Define how the rds should be setup for this env
module "base_rds" {
  source = "../modules/rds"
  owner                         = "${var.owner}"
  env                           = "${var.env}"
  app                           = "${var.app}"
  rds_subnet_id                 = "${var.rds_subnet_id}"


  rds_engine_type                = "${var.rds_engine_type}"
  rds_engine_version              = "${var.rds_engine_version}"
  rds_backup_retention_period     = "${var.rds_backup_retention_period}"
  rds_port                        = "${var.rds_port}"
  rds_publicly_accessible         = "${var.rds_publicly_accessible}"
  rds_auto_minor_version_upgrade  = "${var.rds_auto_minor_version_upgrade}"
  rds_allow_major_version_upgrade = "${var.rds_allow_major_version_upgrade}"
  rds_allocated_storage           = "${var.rds_allocated_storage}"
  rds_instance_type              = "${var.rds_instance_type}"
  rds_storage_type                = "${var.rds_storage_type}"
  rds_master_username                    = "${var.rds_master_username}"
  rds_master_password                    = "${var.rds_master_password}"
  rds_iops                        = "${var.rds_iops}"
  rds_multi_az                    = "${var.rds_multi_az}"
  rds_sg_id                       = ["${var.rds_sg_id}"]  
}
