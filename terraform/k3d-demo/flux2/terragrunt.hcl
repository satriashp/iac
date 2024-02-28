terraform {
  source = "../../../manifests/terraform//flux2"
}

inputs = {
  cluster = "k3d-demo"
}
