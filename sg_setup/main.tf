#Define all the required security groups

resource "aws_security_group" "sec_web" {
  name        = "sec_web"
  description = "Used for autoscale group"
  vpc_id      = "${var.vpc_id}"
  tags = {
    Name = "${var.owner}-${var.env}-${var.app}-sec_web"
    app = "${var.app}"
    owner = "${var.owner}"
    env = "${var.env}"
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb" {
  name = "http-egress"
  vpc_id      = "${var.vpc_id}"
  description = "Allow http from elb to ec2 instances"
  tags = {
    Name = "${var.owner}-${var.env}-${var.app}-elb"
    app = "${var.app}"
    owner = "${var.owner}"
    env = "${var.env}"
  }
  # Allow HTTP/HTTPS from ALL  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

}

resource "aws_security_group" "rds" {
    tags = {
    Name = "${var.owner}-${var.env}-${var.app}-rds"
    app = "${var.app}"
    owner = "${var.owner}"
    env = "${var.env}"
  }
  name        = "mysql"
  vpc_id      = "${var.vpc_id}"
  description = "Allow mysql port"
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]  
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion-sg" {
  description = "EC2 Instance Bastion Security Group"
  vpc_id      = "${var.vpc_id}"

  tags = {
    owner      = "${var.owner}"
    env = "${var.env}"
    app         = "${var.app}"
    Name        = "${var.owner}-${var.env}-${var.app}-bastion-sg"
  }

  # Allow SSH Traffic from workstation IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.local_ip}"]
  }

  # Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
