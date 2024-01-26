terraform {
  source = "../../modules//vpc/"
}

include "root" {
  path = find_in_parent_folders()
  expose = true
}

dependency "folder" {
  config_path = "../folder"
  mock_outputs = {
    folder_id = "dummy_id"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  for_each = "${include.root.locals.networks}"
  folder_id    = dependency.folder.outputs.folder_id
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "yandex" {
  cloud_id = "${include.root.locals.cloud_id}"
  folder_id = "${dependency.folder.outputs.folder_id}"
}
EOF
}
