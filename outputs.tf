output "chef_server_url" {
  value = module.ec2.chef_server_url
}

output "chef_server_public_ip" {
  value = module.ec2.chef_server_public_ip
}
