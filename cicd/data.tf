data "aws_ssm_parameter" "github_pat" {
  name = "/github/deanillfeld/pat"
}

resource "random_string" "github_secret" {
  length = 32
}
