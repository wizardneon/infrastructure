# S3 bucket for terroform states
terraform {
  backend "s3" {
    bucket = "state-teraform"
    key    = "states/terraform.tfstate"
    region = "eu-west-1"
    profile = "var.profile"
 }
}
