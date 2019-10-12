variable "env_name" {}

variable "vpc_cidr" {}

variable "nof_public_subnets" {
}

variable "nof_private_subnets" {
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Key/value tags to assign to all AWS resources"
}

variable "azs" {
  type = "list"
}

variable "vpc_id" {
    default = ""
}

variable "private_subnet_tags" {
  default = ""
}

variable "public_subnet_tags" {
  default = ""
}

variable "enable_nat_gateway" {
  default = false
}