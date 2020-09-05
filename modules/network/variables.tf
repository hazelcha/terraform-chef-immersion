#-----------------network module-----------------

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr block"
}

variable "pub_subnets" {
  type        = list
  description = "list of subnet CIDRs"
}

variable "subnet_count" {
  type        = number
  description = "number of subnets required to deploy a chef server and nodes"
}