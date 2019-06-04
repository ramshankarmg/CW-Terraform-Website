resource "aws_internet_gateway" "igw" {
    vpc_id = "${var.vpc_id}"
    tags = {
        Owner = "${var.owner}"
        Env = "${var.env}"
        Name = "${var.owner}-${var.env}-igw"
    }
}
