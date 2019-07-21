resource "aws_internet_gateway" "ig" {
  vpc_id = "${data.aws_vpc.current.id}"
  tags = "${merge(var.tags,
    map("Name", "${var.env_name}-igw")
  )}"
}
