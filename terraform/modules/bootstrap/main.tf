provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "env_namespace" {
  metadata {
    annotations = {
      name = "${var.env}"
    }

    name = "${var.env}"
  }
}

resource "kubernetes_service_account" "service_account" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "${var.env}"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = var.lb_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }

  depends_on = [
    kubernetes_namespace.env_namespace
  ]
}

# ======================================================================================================================
# Helm Charts
# ======================================================================================================================

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "${var.env}"
  depends_on = [
    kubernetes_service_account.service_account, kubernetes_namespace.env_namespace
  ]

  set {
    name  = "region"
    value = "${var.aws_region}"
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

}

# =====================================================================================================================
# Docker Registry Credentials
# =====================================================================================================================

# Need to Add Docker Login Command here or take this step out to predeployment
resource "null_resource" "put_ssm_parameter" {
  provisioner "local-exec" {
    command = <<-EOT
    aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
    aws ssm put-parameter --name /secrets/ecr_pull_token --value $(aws ecr get-login-password) --type SecureString --overwrite
EOT
  }
}

data "aws_ssm_parameter" "ecr_pull_token" {
  name = "/secrets/ecr_pull_token"
  depends_on = [
    null_resource.put_ssm_parameter
  ]
}

resource "kubernetes_secret" "regred" {
  metadata {
    name = "regcred"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.weather_app_repo_url}" = {
          "username" = "${var.registry_username}"
          "password" = "${data.aws_ssm_parameter.ecr_pull_token.value}"
          "namespace"= "${var.env}"
          "auth"     = base64encode("${var.registry_username}:${data.aws_ssm_parameter.ecr_pull_token.value}")
        }
      }
    })
  }

  depends_on = [
    null_resource.put_ssm_parameter, kubernetes_namespace.env_namespace
  ]
}

