data aws_vpc "current" {
    id = "${var.vpc_id == "" ? aws_vpc.vpc.0.id : var.vpc_id }"
}
resource "aws_vpc" "vpc" {
    count = "${var.vpc_id == "" ? 1 : 0}"
    cidr_block           = "${var.vpc_cidr}"
    instance_tenancy     = "default"
    enable_dns_hostnames = true

    tags = "${merge(var.tags,
    map("Name", "${var.env_name}-vpc")
    )}"
}
