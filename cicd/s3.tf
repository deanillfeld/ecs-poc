resource "aws_s3_bucket" "codepipeline" {
  bucket = "ecs-poc-codepipeline"
  acl    = "private"
}
