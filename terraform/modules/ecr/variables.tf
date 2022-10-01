variable "aws_region" {}
variable "aws_profile" {}
variable "account_id" {}
variable "env" {}
variable "az_count" {}
variable "app_name" {}
variable "vpc_id" {}
variable "cluster_name" {}

variable "public_subnets" {
    type = set(string)
}
variable "private_subnets" {
    type = set(string)
}
