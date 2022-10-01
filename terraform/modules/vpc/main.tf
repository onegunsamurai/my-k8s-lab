data "aws_availability_zones" "available" {}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name}-vpc-${var.aws_region}"
  cidr = var.vpc_cidr

  azs             = [for i in range(var.az_count) : data.aws_availability_zones.available.names[i]] #Hardcode here ...
  private_subnets = [for i in range(var.az_count) : var.aws_private_subnets[i]]
  public_subnets  = [for i in range(var.az_count) : var.aws_public_subnets[i]]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb" = "1"
  }
  default_security_group_ingress = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "TCP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 443
      to_port   = 443
      protocol  = "TCP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  default_security_group_egress = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "ALL"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


