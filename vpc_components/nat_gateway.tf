resource "aws_eip" "eip" {
    count      = "${var.env_name == "kube" ? 1 : 0}"
    depends_on = ["aws_internet_gateway.ig"]
    vpc        = true
    tags       = "${var.tags}"
}

resource "aws_nat_gateway" "ngw" {
    count      = "${var.env_name == "kube" ? 1 : 0}"
    depends_on = ["aws_internet_gateway.ig"]
    allocation_id = "${element(aws_eip.eip.*.id,count.index)}"
    subnet_id     = "${element(aws_subnet.private.*.id,count.index)}"
}

resource "aws_route" "private_nat_gateway" {
    count                  = "${var.env_name == "kube" ? 1 : 0}"
    route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "${element(aws_nat_gateway.ngw.*.id, count.index)}"

    timeouts {
        create = "5m"
    }
}