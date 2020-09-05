#-----------------ec2/main.tf-----------------

locals {
  common_tags = {
    project = "chef immersion new starter training"
  }
}

resource "aws_key_pair" "instance_ssh" {
 key_name   = "chef-immersion"
 public_key = file("${path.module}/../../ssh-keys/chef-immersion.pub")
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
 ami                    = data.aws_ami.ubuntu.id
 instance_type          = "t2.medium"
 subnet_id              = module.network.aws_subnet.chef_subnets[0].id
 vpc_security_group_ids = [aws_security_group.chef_sg.id]
 key_name               = aws_key_pair.instance_ssh.key_name

 tags = merge({
   Name = "chef-server"
   },
 local.common_tags)
}

resource "aws_instance" "chef_nodes" {
 count                  = var.node_count
 ami                    = data.aws_ami.ubuntu.id
 instance_type          = "t3.micro"
 subnet_id              = module.network.aws_subnet.chef_subnets[1].id
 vpc_security_group_ids = [aws_security_group.chef_sg.id]
 key_name               = aws_key_pair.instance_ssh.key_name

 tags = merge({
   Name = "chef-node-${count.index + 1}"
   },
 local.common_tags)
}

resource "aws_eip" "chef_server_eip" {
 vpc = true

 instance   = aws_instance.chef_server.id
 depends_on = [aws_internet_gateway.chef_gw]

 tags = local.common_tags
}
