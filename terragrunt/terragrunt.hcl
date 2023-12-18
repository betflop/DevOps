locals {
  cloud_id = "b1gdpfn1c8tdi31r6e8j"
  folder_id = "b1g4n64su4cklrhlua4b"
  backend_bucket     = "demo-terragrunt-states-backend"
  backend_bucket_key = "${path_relative_to_include()}/terraform.tfstate"
  region = "ru-central1-a"
  networks = ["network-11", "network-22"]
  # access_key = get_env("ACCESS_KEY")
  # secret_key = get_env("SECRET_KEY")

  # dynamodb_endpoint  = 
  # dynamodb_table     = "terraform_lock_test"
  access_key         = get_env("ACCESS_KEY")
  secret_key         = get_env("SECRET_KEY")
}

generate "provider" {
  path      = "provider_gen.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "yandex" {
  cloud_id  = "${local.cloud_id}"
  folder_id = "${local.folder_id}"
  zone      = "${local.region}"
}
EOF
}

generate "backend" {
  path      = "backend_gen.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "${local.backend_bucket}"
    region                      = "${local.region}"
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    access_key                  = "${local.access_key}"
    secret_key                  = "${local.secret_key}"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
EOF
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

inputs = {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
}
