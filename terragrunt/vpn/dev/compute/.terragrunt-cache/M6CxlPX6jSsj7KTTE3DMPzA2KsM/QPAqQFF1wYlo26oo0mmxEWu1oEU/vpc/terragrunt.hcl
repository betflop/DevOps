
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

dependency "vpc" {  
  config_path = "../vpc"
  mock_outputs = {
    subnets = {"dummy_name":"dummy_id"}
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]

}

inputs = {
  vm_name = "vpn_vm"
  # subnet_id = dependency.vpc.outputs.subnets["network1-subnet"]
  subnet_id = "enpu386l62imu6j8fhej"
  image_id = "fd8v0s6adqu3ui3rsuap"
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
