terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  zone = "ru-central1-a" 
}

resource "yandex_iam_service_account" "sa" {
  name       = "my-service-account"
  description = "Service account for managing Kubernetes cluster"
}

resource "yandex_kubernetes_cluster" "my-cluster" {
  name       = "my-cluster"
  description = "My Kubernetes cluster"
  network_id = yandex_vpc_network.k8s-network.id

  master {
    version = "1.26"
    zonal {
      zone     = yandex_vpc_subnet.k8s-subnet.zone
      subnet_id = yandex_vpc_subnet.k8s-subnet.id
    }
    public_ip = true
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.editor,
    yandex_resourcemanager_folder_iam_member.images-puller
  ]

  service_account_id      = yandex_iam_service_account.sa.id
  node_service_account_id = yandex_iam_service_account.sa.id

}

resource "yandex_vpc_network" "k8s-network" { name = "k8s-network" }

resource "yandex_vpc_subnet" "k8s-subnet" {
  v4_cidr_blocks = ["10.5.0.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s-network.id
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_kubernetes_node_group" "testgroup" {
  cluster_id = yandex_kubernetes_cluster.my-cluster.id
  name       = "testgroup"
  instance_template {
    name       = "test-{instance.short_id}-{instance_group.id}"
    platform_id = "standard-v1"
    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.k8s-subnet.id}"]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }
    container_runtime {
      type = "containerd"
    }


    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      # user-data = file("startup.sh")
    }



  }
  scale_policy {
    fixed_scale {
      size = 1
    }   
  }
}
