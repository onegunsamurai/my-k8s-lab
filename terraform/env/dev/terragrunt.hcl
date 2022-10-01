#================================================================================================
#                   PLACE FOR YOUR INFORMATION
#================================================================================================

locals {
    aws_region      = "eu-central-1"           #   Region where you want to deploy your application
    environment     = "dev"                 #   The name of your environment
    app_name        = "naviteq-eks-app"         #   Your application name
    aws_profile     = "default"             #   Your local aws profile name. By default equals to "default".
    account_id      = "617686195573"        #   Your AWS Account ID
    number_of_zones = 3                     #   Number of availability zones you want to create

    cluster_name   = "naviteq-test-cluster" #   The name of your EKS cluster

    github_org        = "naviteq"                                   #   Your github organization name
    github_repo       = "lab-work-vladyslav-bukhantsov"             #   Your github repository name
    github_branch     = "main"                                      #   Your github branch name
    path_to_git_token = "/github/Token"                             #   Path to your github token in AWS SSM Parameter Store (Don't change for now)

    commit_tag        = "v1.0.0"                                    #   Your commit tag

    deploy_app        = false
}

#================================================================================================

inputs = {
    aws_region      = local.aws_region
    env             = local.environment
    app_name        = local.app_name
    aws_profile     = local.aws_profile
    account_id      = local.account_id
    az_count        = local.number_of_zones
    cluster_name    = local.cluster_name


    path_to_git_token   = local.path_to_git_token
    github_org          = local.github_org
    github_repo         = local.github_repo
    github_branch       = local.github_branch

    commit_tag          = local.commit_tag
    deploy_app          = local.deploy_app
}

remote_state {
    backend = "s3"
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
    config = {
        bucket     = "${local.app_name}-${local.environment}-bucket"
        key        = "${path_relative_to_include()}/terraform.tfstate"
        region     = local.aws_region
        encrypt    = true
        profile    = local.aws_profile
    }
}
