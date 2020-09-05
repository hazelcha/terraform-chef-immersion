#-----------------root/main.tf-----------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.5.0"
    }
  }
}

# locals {
#   common_tags = {
#     project = "chef immersion new starter training"
#   }
# }

provider "aws" {
  region                  = var.region
  shared_credentials_file = var.cred_path
  profile                 = var.profile
  allowed_account_ids     = var.accounts
}

#resource "aws_vpc" "chef_vpc" {
#  cidr_block           = var.vpc_cidr
#  instance_tenancy     = "default"
#  enable_dns_support   = true
#  enable_dns_hostnames = true
#
#  tags = merge({
#    Name = "chef-vpc"
#    },
#  local.common_tags)
#}
#
#resource "aws_internet_gateway" "chef_gw" {
#  vpc_id = aws_vpc.chef_vpc.id
#
#  tags = {
#    Name = "chef-igw"
#  }
#}
#
#resource "aws_subnet" "chef_subnets" {
#  count                   = var.subnet_count
#  vpc_id                  = aws_vpc.chef_vpc.id
#  cidr_block              = var.pub_subnets[count.index]
#  map_public_ip_on_launch = true
#
#  depends_on = [aws_internet_gateway.chef_gw]
#
#  tags = merge({
#    Name = "public-subnet-${count.index + 1}"
#    },
#  local.common_tags)
#}
#
#resource "aws_route" "r" {
#  route_table_id         = aws_vpc.chef_vpc.main_route_table_id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id             = aws_internet_gateway.chef_gw.id
#}

module "network" {
  source       = "./modules/network"
  vpc_cidr     = var.vpc_cidr
  pub_subnets  = var.pub_subnets
  subnet_count = var.subnet_count
}

# module "ec2" {
#   source       = "./modules/ec2"
#   node_count = var.main_node_count
# }

#resource "aws_security_group" "chef_sg" {
#  name        = "chef_sg"
#  description = "Allowed ports for Chef"
#  vpc_id      = module.network.chef_vpc.id
#
#  ingress {
#    description = "SSH access"
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    description = "TLS for chef server"
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    description = "http for chef server"
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = local.common_tags
#}
#
#resource "aws_key_pair" "instance_ssh" {
#  key_name   = "chef-immersion"
#  public_key = file("${path.module}/ssh-keys/chef-immersion.pub")
#}
#
#data "aws_ami" "ubuntu" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#  }
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#
#  owners = ["099720109477"] # Canonical
#}
#
#resource "aws_instance" "chef_server" {
#  ami                    = data.aws_ami.ubuntu.id
#  instance_type          = "t2.medium"
#  subnet_id              = aws_subnet.chef_subnets[0].id
#  vpc_security_group_ids = [aws_security_group.chef_sg.id]
#  key_name               = aws_key_pair.instance_ssh.key_name
#
#  tags = merge({
#    Name = "chef-server"
#    },
#  local.common_tags)
#}
#
#resource "aws_instance" "chef_nodes" {
#  count                  = var.node_count
#  ami                    = data.aws_ami.ubuntu.id
#  instance_type          = "t3.micro"
#  subnet_id              = aws_subnet.chef_subnets[1].id
#  vpc_security_group_ids = [aws_security_group.chef_sg.id]
#  key_name               = aws_key_pair.instance_ssh.key_name
#
#  tags = merge({
#    Name = "chef-node-${count.index + 1}"
#    },
#  local.common_tags)
#}
#
#resource "aws_eip" "chef_server_eip" {
#  vpc = true
#
#  instance   = aws_instance.chef_server.id
#  depends_on = [aws_internet_gateway.chef_gw]
#
#  tags = local.common_tags
#}