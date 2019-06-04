output "address" {
	value = "${aws_db_instance.rds.address}"
}

output "port" {
	
	value = "${aws_db_instance.rds.port}"
}

output "endpoint" {
	
	value = "${aws_db_instance.rds.endpoint}"
}

output "rds_master_username" {
	value = "${var.rds_master_username}"
}

output "rds_master_password" {
	value = "${var.rds_master_password}"
}
