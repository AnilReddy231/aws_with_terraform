resource "aws_route_table" "public" {
  vpc_id = "${data.aws_vpc.current.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }

  tags = "${merge(var.tags,
    map("Name", "${var.env_name}-public")
  )}"
}

resource "aws_route_table_association" "public" {
  count          = "${var.nof_public_subnets}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table" "private" {
  vpc_id = "${data.aws_vpc.current.id}"

  tags = "${merge(var.tags,
    map("Name", "${var.env_name}-private")
  )}"
}

resource "aws_route_table_association" "private" {
  count          = "${var.nof_private_subnets}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

