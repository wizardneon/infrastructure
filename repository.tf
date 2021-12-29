# ECR repo
resource "aws_ecr_repository" "ecr_for_images" {
  name = "${var.repo_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
  scan_on_push = true
  }
}

