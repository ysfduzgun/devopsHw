provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.keyPath}"
  profile                 = "terraform"
}
