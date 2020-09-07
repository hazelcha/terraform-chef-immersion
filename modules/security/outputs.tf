#-----------------security/outputs.tf-----------------

output "sg_id" {
  value = [aws_security_group.chef_sg.id]
}