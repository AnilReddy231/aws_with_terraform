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
