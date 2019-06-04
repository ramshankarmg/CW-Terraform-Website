resource "aws_route_table" "route_table" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "${var.private_cidr_route}"
        nat_gateway_id = "${var.nat_gateway_id}"
    }
    tags = {
        Owner = "${var.owner}"
        Env = "${var.env}"
        Name = "${var.name}"
    }
}
