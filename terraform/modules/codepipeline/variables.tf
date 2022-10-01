variable "cluster_name" {}


variable "aws_region" {}

variable "aws_profile" {}

variable "app_name" {}

variable "account_id" {}

variable "env" {}


variable "path_to_git_token" {}

variable "github_repo" {}

variable "github_branch" {}

variable "github_org" {}


variable "docker_build_image" {
  default = "aws/codebuild/standard:3.0"
}

variable "timeout" {
  default = "30"
}

variable "compute_type" {
  default = "BUILD_GENERAL1_SMALL"
}


variable "weather_app_repo_url" {}