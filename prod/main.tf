
#VPC
module "vpc" {
    source = "../cluster_setup"
    owner = "${var.owner}"
    env = "${var.env}"

}

#Secuirty Groups
module "sg" {
  source = "../sg_setup"
  owner = "${var.owner}"
  env = "${var.env}"
  app = "${var.app}"
  vpc_id = "${module.vpc.vpc_id}"
  vpc_cidr_block = "${module.vpc.vpc_cidr_block}"
  local_ip  = "${local.my_ip_cidr}"
  
}
#This to ensure that only your local ip is open for ssh into bastion and not open worldwide
data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  my_ip_cidr = "${chomp(data.http.my_ip.body)}/32"
}


#RDS
resource "random_string" "rds_password" {
  length  = 10
  special = false
}

module "rds" {
    source = "../database_setup"
    owner = "${var.owner}"
    env = "${var.env}"
    app = "${var.app}"
    rds_master_password = "${random_string.rds_password.result}"
    rds_sg_id = "${module.sg.rds_id}"
    rds_subnet_id = ["${module.vpc.subnet_private_a_id}", "${module.vpc.subnet_private_b_id}"]
    rds_instance_type = "${var.rds_instance_type}"
    rds_allocated_storage = "${var.rds_allocated_storage}"
    rds_engine_type = "${var.rds_engine_type}"
    rds_engine_version = "${var.rds_engine_version}"
    rds_multi_az = "${var.rds_multi_az}"
}

#APP

# Key Pair - This will take the ~/.ssh/id_rsa file to be your private key and push the ~/.ssh/id_rsa.pub to all machines launched
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.owner}.${var.env}_key_pair"
  public_key = "${data.template_file.ssh_public_key.rendered}"
}

# SSH Public Key File
data "template_file" "ssh_public_key" {
  template = "${file("~/.ssh/id_rsa.pub")}"
}

#Find the right ami irrespective of the region set:
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


locals {
  #Get the defaul ubuntu ami unless overidden from tfvars
  ami_id = "${coalesce(var.aws_image_id, data.aws_ami.ubuntu.id)}"
}




module "app" {
    source = "../app_setup"
    owner = "${var.owner}"
    env = "${var.env}"
    app = "${var.app}"
    key_name = "${aws_key_pair.key_pair.id}"
    ec2_sg_id  = "${module.sg.sec_web_id}"
    elb_sg_id = "${module.sg.elb_id}"
    public_subnet_a_id = "${module.vpc.subnet_public_a_id}"
    public_subnet_b_id = "${module.vpc.subnet_public_b_id}"
    private_subnet_a_id = "${module.vpc.subnet_private_a_id}"
    private_subnet_b_id = "${module.vpc.subnet_private_b_id}"
    db_dbname = "${var.db_dbname}"
    rds_username = "${module.rds.rds_username}"
    rds_password  = "${module.rds.rds_password}"
    rds_host  = "${module.rds.rds_address}"
    aws_image_id  = "${local.ami_id}"
    instance_type = "${var.ec2_instance_type}"
    asg_min_size  = "${var.asg_min_size}"
    asg_max_size  = "${var.asg_max_size}"

}

#Launch a bastion host , so that you can ssh into the wordpress instances launched in private-zone
resource "aws_instance" "bastion" {
  ami                         = "${local.ami_id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${module.vpc.subnet_public_a_id}"
  vpc_security_group_ids      = ["${module.sg.bastion_id}"]
  key_name                    = "${aws_key_pair.key_pair.id}"
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }

  tags = {
    owner       = "${var.owner}"
    env = "${var.env}"
    app = "bastion"
    Name        = "${var.owner}-${var.env}-bastion"
  }
}

