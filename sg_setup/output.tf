output "sec_web_id" {
  value = "${aws_security_group.sec_web.id}"
}

output "elb_id" {
  value = "${aws_security_group.elb.id}"
}

output "rds_id" {
  value = "${aws_security_group.rds.id}"
}

output "bastion_id" {
  value = "${aws_security_group.bastion-sg.id}"
}

