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
        Owner                = "deanillfeld"
        Repo                 = "ecs-poc"
        Branch               = "master"
        OAuthToken           = data.aws_ssm_parameter.github_pat.value
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Docker_Build"

    action {
      name            = "Docker_Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = "ecs-poc-docker"
      }
    }
  }

  stage {
    name = "Terraform_Plan"

    action {
      name            = "Terraform_Plan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = "ecs-poc-tfplan"
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      version  = "1"
      provider = "Manual"
    }
  }

  stage {
    name = "Terraform_Apply"

    action {
      name            = "Terraform_Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = "ecs-poc-tfapply"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "ecs_poc" {
  name            = "ecs-poc"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = random_string.github_secret.result
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}
