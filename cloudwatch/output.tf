output "flowlog_loggroup" {
  value = "${aws_cloudwatch_log_group.flowlog.arn}"
}
