# ECR repo
resource "aws_ecr_repository" "ecr_for_images" {
  name = "${var.repo_name}"
}

