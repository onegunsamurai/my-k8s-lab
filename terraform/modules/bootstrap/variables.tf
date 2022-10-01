variable "aws_region" {}

variable "aws_profile" {}

variable "account_id" {}

variable "env" {}

variable "vpc_id" {}

variable "cluster_name" {}

variable "cluster_endpoint"{}

variable "cluster_ca_cert"{}

variable "lb_role_arn" {}

variable "weather_app_repo_url" {}

variable "registry_username" {
    default = "AWS"
}