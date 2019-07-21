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

variable "log_destination" {
  default = ""
}

variable "accepter_vpc_id" {
    type = "string"  
}

variable "requester_vpc_id" {
    type = "string"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Key/value tags to assign to all AWS resources"
}