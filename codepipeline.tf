# create a 3 stage pipeline
resource "aws_codepipeline" "tf-eks-pipeline" {
  name     = "${var.repo_name}"
  role_arn = "${aws_iam_role.tf-eks-pipeline.arn}"


  stage = {
    name = "StagingDeploy"

    action = {
      name             = "StagingDeploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.tf-eks-deploy-staging.name}"
      }
    }
  }

  stage = {
    name = "PromoteToProd"

    action = {
      name             = "PromoteToProd"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"
    }
 }

  stage = {
    name = "ProdDeploy"

    action = {
      name             = "ProdDeploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.tf-eks-deploy-prod.name}"
      }
    }
  }

}
