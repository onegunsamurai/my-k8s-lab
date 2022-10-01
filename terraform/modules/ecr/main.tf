resource "aws_ecr_repository" "weather_app" {
  name                 = "${var.app_name}-${var.aws_region}-${var.account_id}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "helm_chart_ecr" {
  name                 = "weather-web-app-chart"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
