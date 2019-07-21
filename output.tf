output "tfstate_bucket" {
  value = "${module.s3.bucket_name}"
}

output "flowlog_log_group" {
  value = "${module.cloudwatch.flowlog_loggroup}"
}

output "dev_vpc" {
  value = "${module.vpc.vpc_id}"
}

output "qa_vpc" {
  value = "${module.vpc_qa.vpc_id}"
}

output "flowlog_log_name" {
  value = "${module.vpc_resources.vpc_flowlog}"
}

output "peering_id" {
  value = "${module.vpc_resources.peering_id}"
}

output "accepter_route_tables" {
  value = "${module.vpc_resources.accepter_route_tables}"
}

output "requester_route_tables" {
  value = "${module.vpc_resources.requester_route_tables}"
}