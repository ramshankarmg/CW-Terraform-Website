output "rds_username" {
  value = "${module.base_rds.rds_master_username}"
}

output "rds_password" {
    value = "${module.base_rds.rds_master_password}"
}

output "rds_endpoint" {
  value = "${module.base_rds.endpoint}"
}

output "rds_address" {
  value = "${module.base_rds.address}"
}

