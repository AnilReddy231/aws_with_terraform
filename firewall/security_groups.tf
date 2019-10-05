resource "aws_security_group" "public_sg" {
  name        = "public_security_group"
  description = "Public Security Group"
  vpc_id      = "${var.vpc_id}"
  tags = "${merge(var.tags,
    map("Name", "${var.env_name}-public")
  )}"
}

resource "aws_security_group_rule" "port_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.public_sg.id}"
  cidr_blocks       = ["173.95.51.164/32"]
}

resource "aws_security_group_rule" "default_22" {
  for_each = {for num in var.subnet_numbers: num => num}
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.public_sg.id}"
  cidr_blocks       = cidrsubnet("10.1.0.0/16", 8, each.value)
}


resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  security_group_id = "${aws_security_group.public_sg.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.public_sg.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
