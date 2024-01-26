terraform {
  source = "../../modules//folder/"
}

include "root" {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  name        = "vpn-f"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "yandex" {
  cloud_id = "${include.root.locals.cloud_id}"
}
EOF
}
