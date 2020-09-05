variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidr block"
}
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "accounts" {
  type        = list
  description = "List of allowed AWS account IDs to prevent you from mistakenly using an incorrect one"
}

variable "pub_subnets" {
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "list of subnet CIDRs"
}

variable "subnet_count" {
  type        = number
  default     = 2
  description = "number of subnets required to deploy a chef server and nodes"
}

variable "node_count" {
  type        = number
  description = "number of nodes required"
}
