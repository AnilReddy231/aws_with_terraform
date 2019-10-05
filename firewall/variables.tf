variable "env_name" {
}

variable "tags" {
  type = "map"
  default = {
    Division    = "Infra"
    Management  = "Terraform"
    Owner       = "digital.product"
    MonitorType = "New Relic"
    }
}
variable "vpc_id" {
  
}

variable "subnet_numbers" {
  description = "List of 8-bit numbers of subnets of base_cidr_block that should be granted access."
  default = [1, 2, 3]
}