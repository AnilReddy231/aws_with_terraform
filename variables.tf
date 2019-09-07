variable "tags" {
  type = "map"
  default = {
    Division    = "Infra"
    Management  = "Terraform"
    MonitorType = "New Relic"
    }
}

variable "region" {
  default = "us-east-1"
}

variable "ansible_instance_size" {
  default = "t2.micro"
}

variable "controller_dns" {
}

variable "ansible_dns" {
}

variable "env_name" {

}

variable "slave_count" {
  default = 1
}
