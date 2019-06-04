output "vpc_id" {
    value = "${module.base_vpc.vpc_id_out}"
}

output "igw_id" {
    value = "${module.igw.igw_id_out}"
}

output "subnet_public_a_id" {
    value = "${module.subnet_public_a.subnet_id_out}"
}

output "subnet_public_b_id" {
    value = "${module.subnet_public_b.subnet_id_out}"
}

output "subnet_private_a_id" {
    value = "${module.subnet_private_a.subnet_id_out}"
}

output "subnet_private_b_id" {
    value = "${module.subnet_private_b.subnet_id_out}"
}

output "nat_gateway_a_id" {
    value = "${module.nat_gateway_a.nat_gateway_id}"
}

output "nat_gateway_b_id" {
    value = "${module.nat_gateway_b.nat_gateway_id}"
}


output "vpc_cidr_block" {
    value = "${module.base_vpc.vpc_cidr_block}"
}

# output "subnet_public_a_cidr_block" {
#     value = "${module.subnet_public_a.cidr_block}"
# }

# output "subnet_public_b_cidr_block" {
#     value = "${module.subnet_public_b.cidr_block}"
# }

# output "subnet_private_a_cidr_block" {
#     value = "${module.subnet_private_a.cidr_block}"
# }

# output "subnet_private_b_cidr_block" {
#     value = "${module.subnet_private_b.cidr_block}"
# }
