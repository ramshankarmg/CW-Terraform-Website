#create a private subnet in an availability zone with NAT gateway and routing table associated
#output private subnet id and private routing table id applicable for additional private subnet within the same Availability zone

module "subnet_private" {
    source           = "./../subnet"
    name              = "${var.name}"
    cidr_block       = "${var.cidr_block}"
    vpc_id           = "${var.vpc_id}"
    availability_zone= "${var.availability_zone}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
    }

resource "aws_route_table_association" "private_subnet_route_association" {
    subnet_id = "${module.subnet_private.subnet_id_out}"
    route_table_id = "${var.route_table_id}"
}
