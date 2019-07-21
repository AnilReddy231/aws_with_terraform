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