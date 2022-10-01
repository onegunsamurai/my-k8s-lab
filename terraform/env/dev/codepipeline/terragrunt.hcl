terraform {
    source = "../../../modules//codepipeline"
}

include {
    path = find_in_parent_folders()
}

dependencies {
    paths = ["../vpc", "../eks", "../ecr", "../bootstrap"]
}

dependency "vpc" {
    config_path = "../vpc"
}

dependency "eks" {
    config_path = "../eks"
}

dependency "ecr" {
    config_path = "../ecr"
}

dependency "bootstrap" {
    config_path = "../bootstrap"
    skip_outputs = true
}

inputs = {
    weather_app_repo_url = dependency.ecr.outputs.weather_app_repo_url
}