# S3 bucket for terroform states
terraform {
  backend "s3" {
    bucket = "tf-states-for-eks"
    key    = "states/terraform.tfstate"
    region = "eu-west-1"
    profile = "wizardneon"
  }
}

# Retrieve state data from S3
data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket               = "tf-states-for-eks"
    key                  = "states/terraform.tfstate"
    region               = "eu-west-1"
    profile = "wizardneon"
}
