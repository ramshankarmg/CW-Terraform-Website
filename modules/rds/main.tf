resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.owner}-${var.env}"
  subnet_ids = "${var.rds_subnet_id}"

  tags = {
    owner       = "${var.owner}"
    env = "${var.env}"
    app = "${var.app}"
    Name        = "${var.owner}-${var.env}"
  }
}

resource "aws_db_instance" "rds" {
#engine describe the engine type [mysql,oracle etc]
  engine                      = "${var.rds_engine_type}"
  name                        = "${var.owner}${var.env}${var.app}rds"
  apply_immediately           = true
  skip_final_snapshot         = true
  engine_version              = "${var.rds_engine_version}"
  backup_retention_period     = "${var.rds_backup_retention_period}"
  port                        = "${var.rds_port}"
  publicly_accessible         = "${var.rds_publicly_accessible}"
  auto_minor_version_upgrade  = "${var.rds_auto_minor_version_upgrade}"
  allow_major_version_upgrade = "${var.rds_allow_major_version_upgrade}"
  allocated_storage           = "${var.rds_allocated_storage}"
  instance_class              = "${var.rds_instance_type}"
  storage_type                = "${var.rds_storage_type}"
  storage_encrypted           = false   
  identifier   = "${var.owner}-${var.env}-${var.app}"
  username                    = "${var.rds_master_username}"
  password                    = "${var.rds_master_password}"
  iops                        = "${var.rds_iops}"
  multi_az                    = "${var.rds_multi_az}"
  db_subnet_group_name        = "${aws_db_subnet_group.rds_subnet.name}"
  vpc_security_group_ids      = "${var.rds_sg_id}"
  tags = {
    owner       = "${var.owner}"
    env = "${var.env}"
    app = "${var.app}"
    Name        = "${var.owner}-${var.env}-${var.app}-rds-subnet-group"
  }
}
  