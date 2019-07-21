resource "aws_cloudwatch_log_group" "flowlog" {
  name = "${var.flowlog_log_group}"
  tags = "${var.tags}"
}