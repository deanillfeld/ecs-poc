resource "aws_ecr_repository" "nginxdemo" {
  name                 = "nginxdemo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
