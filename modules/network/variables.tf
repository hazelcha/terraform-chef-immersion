#-----------------network module-----------------

variable "vpc_cidr" {
  type        = string
}

variable "pub_subnets" {
  type        = list
}
