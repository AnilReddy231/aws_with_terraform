resource "aws_security_group" "private_dj" {
  name        = "private_dj_security_group"
  description = "Private DJ Security Group"
  vpc_id      = "${var.vpc_id}"
  tags = "${merge(var.tags,
    map("Name", "${var.env_name}-private_dj")
  )}"
}

resource "aws_security_group_rule" "dj_1389" {
  type              = "ingress"
  from_port         = 1389
  to_port           = 1389
  protocol          = "tcp"
  security_group_id = "${aws_security_group.private_dj.id}"
  cidr_blocks       = ["173.95.51.163/32"]
}

resource "aws_security_group_rule" "dj_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.private_dj.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
