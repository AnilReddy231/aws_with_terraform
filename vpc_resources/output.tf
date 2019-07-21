output "vpc_flowlog" {
  value = "${aws_flow_log.vpc_flow_log.0.id}"
}

output "peering_id" {
  value = "${aws_vpc_peering_connection.peering.id}"
}

output "accepter_route_tables" {
  value = "${data.aws_route_tables.accepter.ids}"
}

output "requester_route_tables" {
  value = "${data.aws_route_tables.requester.ids}"
}
