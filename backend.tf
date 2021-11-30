# S3 bucket for terroform states
terraform {
  backend "s3" {
    bucket = "tf-states-for-eks"
    key    = "states/terraform.tfstate"
    region = "eu-west-1"
    access_key = "AKIA5FGUA55FMMJWX4PT"
    secret_key = "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"
  }
}

# Retrieve state data from S3
data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket               = "tf-states-for-eks"
    key                  = "states/terraform.tfstate"
    region               = "eu-west-1"
    access_key = "AKIA5FGUA55FMMJWX4PT"
    secret_key = "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"
  }
}
