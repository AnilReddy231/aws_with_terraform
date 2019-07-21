resource "aws_cloudwatch_log_group" "flowlog" {
  name = "${var.flowlog_log_group}"
  tags = "${var.tags}"
}

resource "aws_flow_log" "vpc_flow_log" {
  count = "${var.flowlog_needed ? 1 : 0}"
  iam_role_arn    = "${var.flowlog_role_arn}"
  log_destination = "${aws_cloudwatch_log_group.flowlog.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${var.vpc_id}"
}