resource aws_s3_bucket "terraform_state"{
    bucket_prefix = "terraform-state-"
    acl = "private"

    tags = "${var.tags}"
}