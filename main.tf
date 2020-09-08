#-----------------root/main.tf-----------------

terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1.2"
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
  source      = "./modules/network"
  vpc_cidr    = var.vpc_cidr
  pub_subnets = var.pub_subnets
}

module "ec2" {
  source                = "./modules/ec2"
  node_count            = var.node_count
  chef_server_subnet_id = module.network.chef_server_subnet_id
  chef_nodes_subnet_id  = module.network.chef_nodes_subnet_id
  chef_sg               = module.security.sg_id
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.chef_vpc_id
}

resource "null_resource" "example_provisioner" {
  triggers = {
    chef_instance = module.ec2.chef_server_id
  }

  connection {
    type        = "ssh"
    host        = module.ec2.chef_server_public_ip
    user        = "ubuntu"
    private_key = file("${path.module}/chef-files/chef-immersion")
  }

  provisioner "remote-exec" {
    script = "bin/wait-for-bootstrap.sh"
  }

  provisioner "local-exec" {
    command = "scp -i ./chef-files/chef-immersion ubuntu@${module.ec2.chef_server_public_ip}:/drop/chefadmin.pem ./chef-files/"
  }
}
