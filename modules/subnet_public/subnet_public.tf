#create a public subnet in an availability zone with Internet gateway and routing table associated
#output public subnet id

module "subnet_public" {
    source           = "./../subnet"
    name              = "${var.name}"
    cidr_block       = "${var.cidr_block}"
    vpc_id           = "${var.vpc_id}"
    availability_zone= "${var.availability_zone}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}


#associate public routing table with subnet
resource "aws_route_table_association" "public_subnet_route_association" {
    subnet_id = "${module.subnet_public.subnet_id_out}"
    route_table_id = "${var.route_table_id}"
}
