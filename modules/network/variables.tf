#-----------------network module-----------------

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr block"
}

variable "pub_subnets" {
  type        = list
  description = "list of subnet CIDRs"
}
