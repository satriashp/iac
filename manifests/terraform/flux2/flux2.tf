terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.9.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_context = "k3d-local"
    config_path    = "~/.kube/config"
  }
}

resource "helm_release" "this" {
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = "true"

  values = [
    file("${path.module}/values.yaml")
  ]
}
