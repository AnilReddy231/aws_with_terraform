data "aws_vpc" "accepter" {
  id = "${var.accepter_vpc_id}"
}

data "aws_vpc" "requester" {
  id = "${var.requester_vpc_id}"
}

resource "aws_vpc_peering_connection" "intra_peering" {
  peer_owner_id = "${data.aws_vpc.accepter.owner_id}"
  peer_vpc_id   = "${var.accepter_vpc_id}"
  vpc_id        = "${var.requester_vpc_id}"
  auto_accept   = true
  
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags          = "${ merge(var.tags, 
    map("Name", "Peering between ${var.accepter_vpc_id} and ${var.requester_vpc_id}"))
  }"
}

data "aws_route_tables" "requester" {
  vpc_id = "${var.requester_vpc_id}"
  filter {
    name   = "tag:Division"
    values = ["Infra"]
  }
}

data "aws_route_tables" "accepter" {
  vpc_id = "${var.accepter_vpc_id}"
  filter {
    name   = "tag:Division"
    values = ["Infra"]
  }
}

resource "aws_route" "accepter" {
    count   = "${length(data.aws_route_tables.accepter.ids)}"
    route_table_id = "${tolist(data.aws_route_tables.accepter.ids)[count.index]}"
    destination_cidr_block  = "${data.aws_vpc.requester.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}

resource "aws_route" "requester" {
    count   = "${length(data.aws_route_tables.requester.ids)}"
    route_table_id = "${tolist(data.aws_route_tables.requester.ids)[count.index]}"
    destination_cidr_block  = "${data.aws_vpc.accepter.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}
