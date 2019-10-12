output "vpc_id" {
  value = "${data.aws_vpc.current.id}"
}

output "public_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.private.*.id}"
}

output "region" {
  value = "${data.aws_region.current.name}"
}

# output "nat_gw_id" {
#   value = "${aws_vpc.vpc.}"
# }
