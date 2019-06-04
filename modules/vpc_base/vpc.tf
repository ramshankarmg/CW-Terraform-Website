resource "aws_vpc" "vpc" {
    cidr_block           = "${var.cidr_block}"
    enable_dns_hostnames = true
    tags = {
        Owner  = "${var.owner}"
        Env  = "${var.env}"
        Name = "${var.owner}-${var.env}-vpc"
    }
}
