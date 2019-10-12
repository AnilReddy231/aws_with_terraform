resource aws_s3_bucket "terraform_state"{
    bucket_prefix = "terraform-state-"
    acl = "private"
    
    versioning {
    enabled = true
    }
    
    tags = "${var.tags}"
}