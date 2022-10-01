  # In case one need to configure EKS security group with custom configs
  resource "aws_security_group" "eks" {
    name        = "${var.cluster_name}-sg"
    description = "Allow traffic"
    vpc_id      = var.vpc_id

    ingress {
      description      = "World"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "EKS ${var.env}"
    }
  }

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.26.2"

  cluster_version = "1.22"
  cluster_name    = var.cluster_name
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets
  enable_irsa     = true

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_additional_security_group_ids = [aws_security_group.eks.id]

  # Self Managed Node Group(s)
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    instance_types         = ["t3.small", "t3.medium"]
    vpc_security_group_ids = [aws_security_group.eks.id]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      taints = {
      }
    }
  }
}

module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.env}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.env}:aws-load-balancer-controller"]
    }
  }
}

