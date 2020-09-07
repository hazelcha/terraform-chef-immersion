#-----------------network/outputs.tf-----------------

output "chef_server_subnet_id" {
  value = aws_subnet.chef_subnets[0].id
}

output "chef_nodes_subnet_id" {
  value = aws_subnet.chef_subnets[1].id
}

output "chef_vpc_id" {
  value = aws_vpc.chef_vpc.id
}
