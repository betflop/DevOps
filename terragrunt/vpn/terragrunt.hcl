locals {
  cloud_id = "b1gdpfn1c8tdi31r6e8j"
  region = "ru-central1-a"
  networks = ["network-1"]
}


generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
    required_providers {
      yandex = {
        source  = "yandex-cloud/yandex"
        version = ">=0.99.0"
      }
    }
  }
  EOF
}
