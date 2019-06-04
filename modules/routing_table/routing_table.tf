resource "aws_route_table" "route_table" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "${var.public_cidr_route}"
        gateway_id = "${var.gateway_id}"
    }
    tags = {
        Owner = "${var.owner}"
        Env = "${var.env}"
        Name = "${var.owner}-${var.env}-public-rt"
    }
}