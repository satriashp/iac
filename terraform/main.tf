provider "helm" {
  kubernetes {
    config_context = "k3d-local"
    config_path    = "~/.kube/config"
    # host                   = var.host
    # client_certificate     = base64decode(var.client_certificate)
    # client_key             = base64decode(var.client_key)
    # cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}

resource "helm_release" "this" {
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = "true"
}
