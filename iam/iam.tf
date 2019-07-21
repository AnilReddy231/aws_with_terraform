resource "aws_iam_role" "flowlog_role" {
  name = "${var.flowlog_role}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

data "template_file" "flowlog_policy"{
    template = "${file("${path.module}/flowlog_policy.json")}"
}

resource "aws_iam_role_policy" "flowlog_role" {
    name = "${var.flowlog_policy}"
    role = "${aws_iam_role.flowlog_role.name}"
    policy = "${data.template_file.flowlog_policy.rendered}"
}
