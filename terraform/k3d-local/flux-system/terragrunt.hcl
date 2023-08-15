terraform {
  source = "../../../manifests/terraform//flux-system"
}

dependency "flux2" {
  config_path = "../flux2"
  skip_outputs = true
}
