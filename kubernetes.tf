locals {
  cluster_name                 = "k8s-qa.anilens.com"
  master_autoscaling_group_ids = ["${aws_autoscaling_group.master-eu-west-2a-masters-k8s-qa-anilens-com.id}"]
  master_security_group_ids    = ["${aws_security_group.masters-k8s-qa-anilens-com.id}"]
  masters_role_arn             = "${aws_iam_role.masters-k8s-qa-anilens-com.arn}"
  masters_role_name            = "${aws_iam_role.masters-k8s-qa-anilens-com.name}"
  node_autoscaling_group_ids   = ["${aws_autoscaling_group.nodes-k8s-qa-anilens-com.id}"]
  node_security_group_ids      = ["${aws_security_group.nodes-k8s-qa-anilens-com.id}"]
  node_subnet_ids              = ["${aws_subnet.eu-west-2a-k8s-qa-anilens-com.id}", "${aws_subnet.eu-west-2b-k8s-qa-anilens-com.id}"]
  nodes_role_arn               = "${aws_iam_role.nodes-k8s-qa-anilens-com.arn}"
  nodes_role_name              = "${aws_iam_role.nodes-k8s-qa-anilens-com.name}"
  region                       = "eu-west-2"
  route_table_public_id        = "${aws_route_table.k8s-qa-anilens-com.id}"
  subnet_eu-west-2a_id         = "${aws_subnet.eu-west-2a-k8s-qa-anilens-com.id}"
  subnet_eu-west-2b_id         = "${aws_subnet.eu-west-2b-k8s-qa-anilens-com.id}"
  vpc_cidr_block               = "${aws_vpc.k8s-qa-anilens-com.cidr_block}"
  vpc_id                       = "${aws_vpc.k8s-qa-anilens-com.id}"
}

output "cluster_name" {
  value = "k8s-qa.anilens.com"
}

output "master_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.master-eu-west-2a-masters-k8s-qa-anilens-com.id}"]
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-k8s-qa-anilens-com.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-k8s-qa-anilens-com.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-k8s-qa-anilens-com.name}"
}

output "node_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.nodes-k8s-qa-anilens-com.id}"]
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-k8s-qa-anilens-com.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.eu-west-2a-k8s-qa-anilens-com.id}", "${aws_subnet.eu-west-2b-k8s-qa-anilens-com.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-k8s-qa-anilens-com.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-k8s-qa-anilens-com.name}"
}

output "region" {
  value = "eu-west-2"
}

output "route_table_public_id" {
  value = "${aws_route_table.k8s-qa-anilens-com.id}"
}

output "subnet_eu-west-2a_id" {
  value = "${aws_subnet.eu-west-2a-k8s-qa-anilens-com.id}"
}

output "subnet_eu-west-2b_id" {
  value = "${aws_subnet.eu-west-2b-k8s-qa-anilens-com.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.k8s-qa-anilens-com.cidr_block}"
}

output "vpc_id" {
  value = "${aws_vpc.k8s-qa-anilens-com.id}"
}

resource "aws_autoscaling_group" "master-eu-west-2a-masters-k8s-qa-anilens-com" {
  name                 = "master-eu-west-2a.masters.k8s-qa.anilens.com"
  launch_configuration = "${aws_launch_configuration.master-eu-west-2a-masters-k8s-qa-anilens-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.eu-west-2a-k8s-qa-anilens-com.id}"]
  tags = [
    {
    key                 = "KubernetesCluster"
    value               = "k8s-qa.anilens.com"
    propagate_at_launch = true
    },
    {
    key                 = "Name"
    value               = "master-eu-west-2a.masters.k8s-qa.anilens.com"
    propagate_at_launch = true
    },
    {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-eu-west-2a"
    propagate_at_launch = true
    },
    {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
    }
  ]
  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-k8s-qa-anilens-com" {
  name                 = "nodes.k8s-qa.anilens.com"
  launch_configuration = "${aws_launch_configuration.nodes-k8s-qa-anilens-com.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.eu-west-2a-k8s-qa-anilens-com.id}", "${aws_subnet.eu-west-2b-k8s-qa-anilens-com.id}"]

  tags = [
    {
    key                 = "KubernetesCluster"
    value               = "k8s-qa.anilens.com"
    propagate_at_launch = true
  },
  {
    key                 = "Name"
    value               = "nodes.k8s-qa.anilens.com"
    propagate_at_launch = true
  },
  {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  },
  {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
  ]
  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "a-etcd-events-k8s-qa-anilens-com" {
  availability_zone = "eu-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "a.etcd-events.k8s-qa.anilens.com"
    "k8s.io/etcd/events"                       = "a/a"
    "k8s.io/role/master"                       = "1"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
  }
}

resource "aws_ebs_volume" "a-etcd-main-k8s-qa-anilens-com" {
  availability_zone = "eu-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "a.etcd-main.k8s-qa.anilens.com"
    "k8s.io/etcd/main"                         = "a/a"
    "k8s.io/role/master"                       = "1"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-k8s-qa-anilens-com" {
  name = "masters.k8s-qa.anilens.com"
  role = "${aws_iam_role.masters-k8s-qa-anilens-com.name}"
}

resource "aws_iam_instance_profile" "nodes-k8s-qa-anilens-com" {
  name = "nodes.k8s-qa.anilens.com"
  role = "${aws_iam_role.nodes-k8s-qa-anilens-com.name}"
}

resource "aws_iam_role" "masters-k8s-qa-anilens-com" {
  name               = "masters.k8s-qa.anilens.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.k8s-qa.anilens.com_policy")}"
}

resource "aws_iam_role" "nodes-k8s-qa-anilens-com" {
  name               = "nodes.k8s-qa.anilens.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.k8s-qa.anilens.com_policy")}"
}

resource "aws_iam_role_policy" "masters-k8s-qa-anilens-com" {
  name   = "masters.k8s-qa.anilens.com"
  role   = "${aws_iam_role.masters-k8s-qa-anilens-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.k8s-qa.anilens.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-k8s-qa-anilens-com" {
  name   = "nodes.k8s-qa.anilens.com"
  role   = "${aws_iam_role.nodes-k8s-qa-anilens-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.k8s-qa.anilens.com_policy")}"
}

resource "aws_internet_gateway" "k8s-qa-anilens-com" {
  vpc_id = "${aws_vpc.k8s-qa-anilens-com.id}"

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "k8s-qa.anilens.com"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
  }
}

resource "aws_key_pair" "kubernetes-k8s-qa-anilens-com-394009d3cb2c9dd6e44c02128b008910" {
  key_name   = "kubernetes.k8s-qa.anilens.com-39:40:09:d3:cb:2c:9d:d6:e4:4c:02:12:8b:00:89:10"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.k8s-qa.anilens.com-394009d3cb2c9dd6e44c02128b008910_public_key")}"
}

resource "aws_launch_configuration" "master-eu-west-2a-masters-k8s-qa-anilens-com" {
  name_prefix                 = "master-eu-west-2a.masters.k8s-qa.anilens.com-"
  image_id                    = "ami-07a64e50756d630d8"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-k8s-qa-anilens-com-394009d3cb2c9dd6e44c02128b008910.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-k8s-qa-anilens-com.id}"
  security_groups             = ["${aws_security_group.masters-k8s-qa-anilens-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-eu-west-2a.masters.k8s-qa.anilens.com_user_data")}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-k8s-qa-anilens-com" {
  name_prefix                 = "nodes.k8s-qa.anilens.com-"
  image_id                    = "ami-07a64e50756d630d8"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-k8s-qa-anilens-com-394009d3cb2c9dd6e44c02128b008910.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-k8s-qa-anilens-com.id}"
  security_groups             = ["${aws_security_group.nodes-k8s-qa-anilens-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.k8s-qa.anilens.com_user_data")}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_route" "wide_open" {
  route_table_id         = "${aws_route_table.k8s-qa-anilens-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.k8s-qa-anilens-com.id}"
}

resource "aws_route_table" "k8s-qa-anilens-com" {
  vpc_id = "${aws_vpc.k8s-qa-anilens-com.id}"

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "k8s-qa.anilens.com"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
    "kubernetes.io/kops/role"                  = "public"
  }
}

resource "aws_route_table_association" "eu-west-2a-k8s-qa-anilens-com" {
  subnet_id      = "${aws_subnet.eu-west-2a-k8s-qa-anilens-com.id}"
  route_table_id = "${aws_route_table.k8s-qa-anilens-com.id}"
}

resource "aws_route_table_association" "eu-west-2b-k8s-qa-anilens-com" {
  subnet_id      = "${aws_subnet.eu-west-2b-k8s-qa-anilens-com.id}"
  route_table_id = "${aws_route_table.k8s-qa-anilens-com.id}"
}

resource "aws_security_group" "masters-k8s-qa-anilens-com" {
  name        = "masters.k8s-qa.anilens.com"
  vpc_id      = "${aws_vpc.k8s-qa-anilens-com.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "masters.k8s-qa.anilens.com"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
  }
}

resource "aws_security_group" "nodes-k8s-qa-anilens-com" {
  name        = "nodes.k8s-qa.anilens.com"
  vpc_id      = "${aws_vpc.k8s-qa-anilens-com.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "nodes.k8s-qa.anilens.com"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-k8s-qa-anilens-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-k8s-qa-anilens-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "eu-west-2a-k8s-qa-anilens-com" {
  vpc_id            = "${aws_vpc.k8s-qa-anilens-com.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "eu-west-2a"

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "eu-west-2a.k8s-qa.anilens.com"
    SubnetType                                 = "Public"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
    "kubernetes.io/role/elb"                   = "1"
  }
}

resource "aws_subnet" "eu-west-2b-k8s-qa-anilens-com" {
  vpc_id            = "${aws_vpc.k8s-qa-anilens-com.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "eu-west-2b"

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "eu-west-2b.k8s-qa.anilens.com"
    SubnetType                                 = "Public"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
    "kubernetes.io/role/elb"                   = "1"
  }
}

resource "aws_vpc" "k8s-qa-anilens-com" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "k8s-qa.anilens.com"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "k8s-qa-anilens-com" {
  domain_name         = "eu-west-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                          = "k8s-qa.anilens.com"
    Name                                       = "k8s-qa.anilens.com"
    "kubernetes.io/cluster/k8s-qa.anilens.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "k8s-qa-anilens-com" {
  vpc_id          = "${aws_vpc.k8s-qa-anilens-com.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.k8s-qa-anilens-com.id}"
}
