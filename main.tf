#-----------------root/main.tf-----------------

terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = var.cred_path
  profile                 = var.profile
  allowed_account_ids     = var.accounts
}

module "network" {
  source       = "./modules/network"
  vpc_cidr     = var.vpc_cidr
  pub_subnets  = var.pub_subnets
  subnet_count = var.subnet_count
}

module "ec2" {
  source                = "./modules/ec2"
  node_count            = var.main_node_count
  chef_server_subnet_id = module.network.chef_server_subnet_id
  chef_nodes_subnet_id  = module.network.chef_nodes_subnet_id
}

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
