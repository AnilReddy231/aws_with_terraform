variable "flowlog_log_group" {
  type = "string"
}

variable "tags" {
    type = "map"
    default = {}
}

variable "flowlog_role_arn" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "flowlog_needed" {
  type = bool
  default = false
}
