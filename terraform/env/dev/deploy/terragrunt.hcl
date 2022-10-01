terraform {
    source = "../../../modules//deploy"
}

include {
    path = find_in_parent_folders()
}

dependencies {
    paths = ["../vpc", "../eks", "../ecr", "../bootstrap", "../codepipeline"]
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        vpc_id              = "vpc-000000000000"
        public_subnets      = ["subnet-00000000000", "subnet-111111111111", "subnet-111111111111"]
        private_subnets     = ["subnet-22222222222", "subnet-444444444444", "subnet-111111111111"] #Some weak spot here. What if we have more than two subs requested...
    }
}

dependency "eks" {
    config_path = "../eks"
}

dependency "ecr" {
    config_path = "../ecr"
}


dependency "bootsrap" {
    config_path = "../bootstrap"
    skip_outputs = true
}

dependency "codepipeline" {
    config_path = "../codepipeline"
    skip_outputs = true
}


inputs = {
    vpc_id           = dependency.vpc.outputs.vpc_id
    public_subnets   = dependency.vpc.outputs.public_subnets
    private_subnets  = dependency.vpc.outputs.private_subnets

    cluster_endpoint = dependency.eks.outputs.cluster_endpoint
    cluster_ca_cert  = dependency.eks.outputs.cluster_ca_cert
    lb_role_arn      = dependency.eks.outputs.lb_role_arn

    weather_app_repo_url = dependency.ecr.outputs.weather_app_repo_url
    helm_chart_repo_url  = dependency.ecr.outputs.helm_chart_repo_url
}
