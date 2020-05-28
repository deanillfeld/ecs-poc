resource "aws_codepipeline" "codepipeline" {
  name     = "ecs-poc-master"
  role_arn = aws_iam_role.codebuild.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner  = "deanillfeld"
        Repo   = "ecs-poc"
        Branch = "master"
        OAuthToken = data.aws_ssm_parameter.github_pat.value
      }
    }
  }

  stage {
    name = "Docker_Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName = "ecs-poc-docker"
      }
    }
  }

  stage {
    name = "Terraform_Plan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName = "ecs-poc-tfplan"
      }
    }
  }

  stage {
    name = "Terraform_Apply"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName = "ecs-poc-tfapply"
      }
    }
  }
}
