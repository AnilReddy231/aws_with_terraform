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

output "kube_vpc" {
  value = "${module.vpc_kube.vpc_id}"
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

output "root_pass" {
  value = "${module.instance.rootUserPassword}"
  sensitive = true
}

output "monitor_pass" {
    value = "${module.instance.monitorUserPassword}"
    sensitive = true
}

output "private_key" {
	value = "${module.instance.generated_key}"
  sensitive = true
}

output "kubernetes_cluster_name" {
  value = "${local.kubernetes_cluster_name}"
}

output "k8s_api_http" {
  value = "${module.kube_firewall.k8s_api_http}"
}
output "kube_region" {
  value = "${module.vpc_kube.region}"
}

output "avlb_zones" {
  value = "${local.azs}"
}

output "kube_cidr" {
  value = "${local.kube_cidr}"
}

output "kube_public_subnets" {
  value = "${module.vpc_kube.public_subnets}"
}

output "kube_private_subnets" {
  value = "${module.vpc_kube.private_subnets}"
}