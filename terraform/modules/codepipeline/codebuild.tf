resource "aws_codebuild_project" "project" {
  name          = var.app_name
  description   = "CodeBuild Project for All Envs" # Some description if needed here
  build_timeout = var.timeout
  
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = var.compute_type
    image        = var.docker_build_image
    type         = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = "${var.aws_region}"
    }

    environment_variable {
      name  = "APP_NAME"
      value = "${var.app_name}"
    }

    environment_variable {
      name  = "APP_ENV"
      value = "${var.env}"
    }

    environment_variable {
        name  = "REPOSITORY_URL"
        value = "${var.weather_app_repo_url}"
    }

    environment_variable {
        name  = "CLUSTER_NAME"
        value = "${var.cluster_name}"
    }

    environment_variable {
        name    = "REPO_NAME"
        value   = "${var.app_name}-${var.aws_region}-${var.account_id}"
    }

    environment_variable {
        name    = "ACCOUNT_ID"
        value   = "${var.account_id}"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "${file("buildspec.yaml")}"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}