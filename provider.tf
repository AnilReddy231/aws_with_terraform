provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

provider "aws" {
  region = "eu-west-2"
  alias  = "west"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}
