# S3 bucket for terroform states
terraform {
  backend "s3" {
    bucket = "state-teraform"
    key    = "states/terraform.tfstate"
    region = var.aws_region
    profile = var.profile
}

# Retrieve state data from S3
#data "terraform_remote_state" "state" {
#  backend = "s3"
#  config = {
#    bucket               = "state-teraform"
#    key                  = "states/terraform.tfstate"
#    region               = "eu-west-1"
#    profile = "wizardneon"
# }
#}
