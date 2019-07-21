output "tfstate_bucket" {
  value = "${module.s3.bucket_name}"
}
