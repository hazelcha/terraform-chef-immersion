#-----------------ec2/main.tf-----------------

locals {
  common_tags = {
    project = "chef immersion new starter training"
  }
}

resource "aws_key_pair" "instance_ssh" {
  key_name   = "chef-immersion"
  public_key = file("${path.module}/../../chef-files/chef-immersion.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "chef_server" {
  # depends_on = [aws_eip.chef_server_eip]
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.chef_server_subnet_id
  vpc_security_group_ids = var.chef_sg
  key_name               = aws_key_pair.instance_ssh.key_name
  user_data              = file("${path.module}/template-files/user-data.tmpl")

  tags = merge({
    Name = "chef-server"
    },
  local.common_tags)
}

resource "aws_instance" "chef_nodes" {
  count                  = var.node_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.chef_nodes_subnet_id
  vpc_security_group_ids = var.chef_sg
  key_name               = aws_key_pair.instance_ssh.key_name

  tags = merge({
    Name = "chef-node-${count.index + 1}"
    },
  local.common_tags)
}

resource "aws_eip" "chef_server_eip" {
  vpc      = true
  instance = aws_instance.chef_server.id

  provisioner "local-exec" {
    command = "echo 'current_dir = File.dirname(__FILE__)\nlog_level :info\nlog_location STDOUT\nnode_name \"chefadmin\"\nclient_key \"#{current_dir}/chefadmin.pem\"\nknife[:editor]=\"/usr/bin/vim\" \nchef_server_url \"https://${aws_eip.chef_server_eip.public_dns}/organizations/hizzleinc\"' > ./chef-files/knife.rb"
  }

  tags = local.common_tags
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.chef_server.id
  allocation_id = aws_eip.chef_server_eip.id
}
