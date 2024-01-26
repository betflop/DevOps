
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
  for_each = ["network-11", "network-22"]
  folder_id    = dependency.folder.outputs.folder_id
  subnet_name  = "-subnet"
}


# generate "provider" {
#   path      = "provider.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOT
# provider "yandex" {
#   cloud_id = "b1gdpfn1c8tdi31r6e8j"
#   folder_id = "b1g4n64su4cklrhlua4b"
# }
# EOT
# }
