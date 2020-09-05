#-----------------network module-----------------
locals {
  common_tags = {
    project = "chef immersion new starter training"
  }
}

resource "aws_vpc" "chef_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name = "chef-vpc"
    },
  local.common_tags)
}

resource "aws_internet_gateway" "chef_gw" {
  vpc_id = aws_vpc.chef_vpc.id

  tags = {
    Name = "chef-igw"
  }
}

resource "aws_subnet" "chef_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.chef_vpc.id
  cidr_block              = var.pub_subnets[count.index]
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.chef_gw]

  tags = merge({
    Name = "public-subnet-${count.index + 1}"
    },
  local.common_tags)
}

resource "aws_route" "r" {
  route_table_id         = aws_vpc.chef_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.chef_gw.id
}
