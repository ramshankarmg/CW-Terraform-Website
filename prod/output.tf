output "vpc-id" {
    value = "${module.vpc.vpc_id}"
}

output "rds-username" {
  value = "${module.rds.rds_username}"
}

output "rds-password" {
  value = "${module.rds.rds_password}"
}

output "rds-endpoint" {
  value = "${module.rds.rds_address}"
}

output "elb-endpoint" {
  value = "${module.app.elb_dns}/crud-php-simple"
}


output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "ssh-user" {
  value = "ubuntu"
}


output "myip" {
  value = "${local.my_ip_cidr}"
}
