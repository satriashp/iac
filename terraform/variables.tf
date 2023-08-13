variable "host" {
  type = string
}

variable "client_certificate" {
  sensitive = true
  type      = string
}

variable "client_key" {
  sensitive = true
  type      = string
}

variable "cluster_ca_certificate" {
  sensitive = true
  type      = string
}
