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

resource "helm_release" "application" {
  count      = var.deploy_app == "true" ? 1 : 0
  name       = "${var.app_name}"
  chart      = "oci://${var.helm_chart_repo_url}"  
  namespace  = "${var.env}"

  set {
    name  = "namespace"
    value = "${var.env}"
  }

  set {
    name  = "image.repository"
    value = "${var.weather_app_repo_url}"
  }

  set {
    name  = "image.tag"
    value = "${var.commit_tag}"
  }
}