terraform {
  backend "s3" {
    bucket  = "terraform-state-20190721003000325900000001"
    key     = "kubernetes/"
    region  = "us-east-1"
    encrypt = "true"
  }
}