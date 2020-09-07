#-----------------ec2/outputs.tf-----------------

output "chef_server_url" {
  value = aws_eip.chef_server_eip.public_dns
}

output "chef_server_public_ip" {
  value = aws_eip.chef_server_eip.public_ip
}