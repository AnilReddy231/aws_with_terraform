variable "tags" {
  type = "map"
  default = {
    Division    = "Infra"
    Management  = "Terraform"
    Owner       = "digital.product"
    MonitorType = "New Relic"
    }
}

variable "region" {
  
}

variable "dj_instance_size" {

}

variable "dj_dns" {

}
variable "env_name" {

}

variable "iam_role"{
  
}