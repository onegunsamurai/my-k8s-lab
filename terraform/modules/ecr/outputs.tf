output "weather_app_repo_url" {
    description = "ECR URL of the weather app"
    value       = aws_ecr_repository.weather_app.repository_url
}

output "helm_chart_repo_url" {
    description = "ECR URL of the helm chart"
    value       = aws_ecr_repository.helm_chart_ecr.repository_url
}
