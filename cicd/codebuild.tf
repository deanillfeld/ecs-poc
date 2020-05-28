resource "aws_codebuild_project" "docker" {
  name = "ecs-poc"
  description = "ecs poc docker build"

  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type = "GITHUB"
    location = "https://github.com/deanillfeld/ecs-poc.git"
  }
}

resource "aws_codebuild_webhook" "main" {
  project_name = aws_codebuild_project.docker.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH,PULL_REQUEST_CREATED,PULL_REQUEST_UPDATED,PULL_REQUEST_REOPENED,PULL_REQUEST_MERGED"
    }
  }
}
