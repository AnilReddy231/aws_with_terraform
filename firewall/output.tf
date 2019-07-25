output "dj_security_group" {
  value = "${aws_security_group.private_dj.id}"
}
