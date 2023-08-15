terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  config_context = "k3d-local"
  config_path    = "~/.kube/config"
}

resource "kubectl_manifest" "repo" {
  yaml_body = file("${path.module}/repo.yaml")
}

resource "kubectl_manifest" "sycn" {
  yaml_body = file("${path.module}/sync.yaml")
}

resource "kubectl_manifest" "secret" {
  yaml_body = file("${path.module}/secret.yaml")
}
