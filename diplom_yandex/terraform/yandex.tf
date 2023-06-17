terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-b"
}

resource "yandex_kubernetes_cluster" "test2" {
 name = "test2"
 network_id = yandex_vpc_network.k8s-network.id
 master {
   zonal {
     zone      = yandex_vpc_subnet.k8s-subnet.zone
     subnet_id = yandex_vpc_subnet.k8s-subnet.id
   }

 public_ip = true
 }
 service_account_id      = "ajeup0345m4ct7bo5h7i"
 node_service_account_id = "ajeup0345m4ct7bo5h7i"
   depends_on = [
     yandex_resourcemanager_folder_iam_member.editor,
     yandex_resourcemanager_folder_iam_member.images-puller
   ]
}

resource "yandex_vpc_network" "k8s-network" { name = "k8s-network" }

resource "yandex_vpc_subnet" "k8s-subnet" {
 v4_cidr_blocks = ["10.5.0.0/24"]
 zone           = "ru-central1-b"
 network_id     = yandex_vpc_network.k8s-network.id
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
 # Service account to be assigned "editor" role.
 folder_id = "b1gqh0pb6mgh1j156sq8"
 role      = "editor"
 member    = "serviceAccount:ajeup0345m4ct7bo5h7i"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
 # Service account to be assigned "container-registry.images.puller" role.
 folder_id = "b1gqh0pb6mgh1j156sq8"
 role      = "container-registry.images.puller"
 member    = "serviceAccount:ajeup0345m4ct7bo5h7i"
}

