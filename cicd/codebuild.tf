resource "aws_codebuild_project" "docker" {
  name = "ecs-poc"
  description = "ecs poc docker build"

  service_role = aws_iam_role.codebuild.name

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
