# S3 bucket for terroform states
terraform {
  backend "s3" {
    bucket = "state-teraform"
    key    = "states/terraform.tfstate"
    region = "var.aws_region"
    profile = "var.profile"
 }
}
