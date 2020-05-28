output "github_webhook_url" {
  value = aws_codepipeline_webhook.ecs_poc.url
}

output "github_webhook_secret" {
  value = random_string.github_secret.result
}
