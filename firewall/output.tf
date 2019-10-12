output "security_group" {
  value = "${aws_security_group.public_sg.id}"
}
output "k8s_api_http" {
  value = "${aws_security_group.k8s_api_http.*.id}"
}
