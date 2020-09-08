#-----------------root/variables.tf-----------------

#-----------------provider variables-----------------

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "accounts" {
  type        = list
  description = "List of allowed AWS account IDs to prevent you from mistakenly using an incorrect one"
}

#-----------------network variables-----------------

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC cidr block"
}

variable "pub_subnets" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "list of subnet CIDRs"
}

#-----------------ec2 variables-----------------
variable "node_count" {
  description = "number of chef nodes to deploy"
}
