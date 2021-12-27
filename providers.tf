# Configure the AWS Provider
provider "aws" {
  version = "~> 2.38.0"
  region  = var.aws_region
}
