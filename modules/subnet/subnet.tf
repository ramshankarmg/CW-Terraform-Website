resource "aws_subnet" "subnet" {
    cidr_block = "${var.cidr_block}"
    vpc_id = "${var.vpc_id}"

    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
    tags = {
        Name = "${var.name}"
    }
}
