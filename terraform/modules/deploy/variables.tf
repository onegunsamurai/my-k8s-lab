variable "aws_region" {}
variable "aws_profile" {}
variable "env" {}
variable "az_count" {}
variable "app_name" {}
variable "vpc_id" {}
variable "cluster_name" {}

variable "cluster_endpoint"{}

variable "cluster_ca_cert"{}

variable "weather_app_repo_url" {}

variable "helm_chart_repo_url" {}

variable "commit_tag" {
    default = "latest"
}

variable "run_init_deploy" {
    default = "fasle"
}

variable "deploy_app" {
    default = "false"
}