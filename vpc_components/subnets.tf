resource "aws_subnet" "private" {
  count             = "${var.nof_private_subnets}"
  vpc_id            = "${data.aws_vpc.current.id}"
  cidr_block        = "${cidrsubnet(data.aws_vpc.current.cidr_block, 3, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "private-${var.env_name}-${element(var.azs, count.index)}"
  }
}

resource "aws_subnet" "public" {
  count             = "${var.nof_public_subnets}"
  vpc_id            = "${data.aws_vpc.current.id}"
  cidr_block        = "${cidrsubnet(data.aws_vpc.current.cidr_block, 3, var.nof_private_subnets + count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "public-${var.env_name}-${element(var.azs, count.index)}"
  }
}
