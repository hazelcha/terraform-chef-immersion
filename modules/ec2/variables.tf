#-----------------ec2/variables.tf-----------------

variable "node_count" {
  type        = number
  description = "number of nodes required"
}

variable "chef_server_subnet_id" {}

variable "chef_nodes_subnet_id" {}
