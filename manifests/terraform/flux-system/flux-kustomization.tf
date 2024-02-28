terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  config_context = var.cluster
  config_path    = "~/.kube/config"
}

resource "kubectl_manifest" "repo" {
  yaml_body = <<YAML
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 1m0s
  ref:
    branch: ${var.branch}
  secretRef:
    name: flux-system
  url: ssh://git@github.com/satriashp/iac

YAML
}

resource "kubectl_manifest" "sync" {
  yaml_body = <<YAML
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 10m0s
  path: ./clusters/${var.cluster}
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
YAML
}

resource "kubectl_manifest" "secret" {
  yaml_body = file("${path.module}/secret.yaml")
}
