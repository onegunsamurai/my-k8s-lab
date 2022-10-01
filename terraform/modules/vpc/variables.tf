variable "aws_region" {}
variable "aws_profile" {}
variable "env" {}
variable "az_count" {}
variable "app_name" {}
variable "cluster_name" {}

variable "vpc_cidr" {
    default = "10.101.0.0/16"
}

variable "aws_public_subnets" {
  default = [
    "10.101.10.0/24",
    "10.101.11.0/24",
    "10.101.12.0/24",
    "10.101.13.0/24"
  ]
}

variable "aws_private_subnets" {
  default = [
    "10.101.20.0/24",
    "10.101.21.0/24",
    "10.101.22.0/24",
    "10.101.23.0/24"
  ]
}

