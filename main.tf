module "vpc" {
  source = "./vpc_components"
  env_name = "dev"
  vpc_cidr = "10.255.172.0/24"
  nof_public_subnets = "1"
  nof_private_subnets = "1"
  tags = "${var.tags}"
  azs = ["us-east-1a"]
}

module "vpc_qa" {
  source = "./vpc_components"
  env_name = "qa"
  vpc_cidr = "172.31.155.0/24"
  nof_public_subnets = "1"
  nof_private_subnets = "1"
  tags = "${var.tags}"
  azs = ["us-east-1d"]
}

/*
module "vpc" {
  source = "./vpc_components"
  env_name = "dev"
  vpc_cidr = "192.168.0.0/24"
  nof_public_subnets = "1"
  nof_private_subnets = "1"
  tags = "${var.tags}"
  azs = ["us-east-1a"]
}
*/

module "s3"{
  source = "./s3_resources"
  tags = "${var.tags}"
}

module "iam" {
  source = "./iam"
  flowlog_role = "flowlog_role"
  flowlog_policy = "flowlog_policy"  
}

module "cloudwatch" {
  source = "./cloudwatch"
  flowlog_log_group = "flowlog_log_group"
  tags = "${var.tags}"
  
}

module "vpc_resources" {
  source            = "./vpc_resources"
  flowlog_needed    = true
  flowlog_role_arn  = "${module.iam.flowlog_arn}"
  vpc_id            = "${module.vpc.vpc_id}"
  log_destination   = "${module.cloudwatch.flowlog_loggroup}"
  requester_vpc_id  = "${module.vpc.vpc_id}"
  accepter_vpc_id   = "${module.vpc_qa.vpc_id}"
}

module "dj_firewall" {
  source   = "./firewall"
  env_name = "${var.env_name}"
  tags     = "${var.tags}"
  vpc_id   = "${module.vpc.vpc_id}"
}

module "dj_instance" {
  source           = "./instance"
  region           = "${var.region}"
  dj_instance_size = "${var.dj_instance_size}"
  sg_id            = "${module.dj_firewall.dj_security_group}"
  subnet_id        = "${module.vpc.public_subnet[0]}"
  dj_dns           = "${var.dj_dns}"
  env_name		     = "${var.env_name}"
  tags             = "${var.tags}"
}

