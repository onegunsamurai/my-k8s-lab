terraform {
    source = "../../../modules//eks"
}

include {
    path = find_in_parent_folders()
}

dependencies {
    paths = ["../vpc"]
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        vpc_id              = "vpc-000000000000"
        public_subnets      = ["subnet-00000000000", "subnet-111111111111", "subnet-111111111111"]
        private_subnets     = ["subnet-22222222222", "subnet-444444444444", "subnet-111111111111"]
    }
}

inputs = {
    vpc_id                      = dependency.vpc.outputs.vpc_id
    public_subnets              = dependency.vpc.outputs.public_subnets
    private_subnets             = dependency.vpc.outputs.private_subnets
}
