
/* This module is responsible for creating one VPC , Two public subnets, Two private subnets, One InternetGW, 
One nat-gateway, public route table and private route table.
This is the common base environment for every other environment.
module vpc_create{
    source = "../cluster_setup"
}
Call this environment in your envionment and it will take care of the basic Networking base creation.
*/

#Create the VPC
module "base_vpc" {
    source  = "../modules/vpc_base"
    cidr_block  = "${var.vpc_cidr_block}"
    owner   = "${var.owner}"
    env = "${var.env}"

}

#Create Internet Gateway
module "igw"{
    source  = "../modules/internet_gateway"
    owner   = "${var.owner}"
    env          = "${var.env}"
    vpc_id           = "${module.base_vpc.vpc_id_out}"
}

#Create and define the route table for public subnets
module "public_route"{
    source  = "../modules/routing_table"
    owner   = "${var.owner}"
    env     = "${var.env}"
    vpc_id  = "${module.base_vpc.vpc_id_out}"
    public_cidr_route  = "${var.public_cidr_route}"
    gateway_id  = "${module.igw.igw_id_out}"
}


#create public subnets in two different availability zones
module "subnet_public_a" {
    source           = "../modules/subnet_public"
    name             = "${var.env}-${var.subnet_1_az}-public"
    cidr_block       = "${var.subnet_1_public_cidr_block}"
    vpc_id           = "${module.base_vpc.vpc_id_out}"
    availability_zone= "${var.subnet_1_az}"
    route_table_id   = "${module.public_route.route_table_id_out}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch_in_public_subnet}"
}

module "subnet_public_b" {
    source = "../modules/subnet_public"
    name             = "${var.env}-${var.subnet_2_az}-public"
    cidr_block = "${var.subnet_2_public_cidr_block}"
    vpc_id  = "${module.base_vpc.vpc_id_out}"
    availability_zone   = "${var.subnet_2_az}"
    route_table_id = "${module.public_route.route_table_id_out}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch_in_public_subnet}"
}


#Create NAT Gateway for both AZ's
module "nat_gateway_a" {
   source    = "../modules/nat_gateway"
   name     = "${var.owner}-${var.env}-a"
   subnet_id = "${module.subnet_public_a.subnet_id_out}"
}

module "nat_gateway_b" {
    source = "../modules/nat_gateway"
    name   = "${var.owner}-${var.env}-b"
    subnet_id = "${module.subnet_public_b.subnet_id_out}"
}

#Create Private route table for both zones
module "private_route_a"{
    source           = "../modules/routing_table_private"
    owner            = "${var.owner}"
    env              = "${var.env}"
    name             =  "${var.env}-private-rt-a"
    vpc_id           = "${module.base_vpc.vpc_id_out}"
    private_cidr_route       = "${var.private_cidr_route}"
    nat_gateway_id   = "${module.nat_gateway_a.nat_gateway_id}"
}

module "private_route_b" {
    source = "../modules/routing_table_private"
    owner   = "${var.owner}"
    env     = "${var.env}"
    name = "${var.env}-private-rt-b"
    vpc_id           = "${module.base_vpc.vpc_id_out}"
    private_cidr_route       = "${var.private_cidr_route}"
    nat_gateway_id   = "${module.nat_gateway_b.nat_gateway_id}"     
}

#create private subnets in two different availability zones
module "subnet_private_a" {
    source           = "../modules/subnet_private"
    name             = "${var.env}-${var.subnet_1_az}-private"
    cidr_block       = "${var.subnet_1_private_cidr_block}"
    vpc_id           = "${module.base_vpc.vpc_id_out}"
    availability_zone= "${var.subnet_1_az}"
    route_table_id  =  "${module.private_route_a.route_table_id_out}"
    map_public_ip_on_launch ="${var.map_public_ip_on_launch_in_private_subnet}"
}

module "subnet_private_b" {
    source           = "../modules/subnet_private"
    name             = "${var.env}-${var.subnet_2_az}-private"
    cidr_block       = "${var.subnet_2_private_cidr_block}"
    vpc_id           = "${module.base_vpc.vpc_id_out}"
    availability_zone= "${var.subnet_2_az}"
    route_table_id  =  "${module.private_route_b.route_table_id_out}"
    map_public_ip_on_launch ="${var.map_public_ip_on_launch_in_private_subnet}"

}
