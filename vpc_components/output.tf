output "vpc_id" {
  value = "${data.aws_vpc.current.id}"
}

output "public_subnet" {
  value = "${aws_subnet.public.*.id}"
}

output "private_subnet" {
  value = "${aws_subnet.private.*.id}"
}