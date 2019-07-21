module "vpc" {
  source = "./vpc_components"
  env_name = "dev"
  vpc_cidr = "10.255.172.0/24"
  nof_public_subnets = "1"
  nof_private_subnets = "1"
  tags = "${var.tags}"
  azs = ["us-east-1a"]
}

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
  flowlog_needed = true
  flowlog_role_arn = "${module.iam.flowlog_arn}"
  vpc_id = "${module.vpc.vpc_id}"
}
