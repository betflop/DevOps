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
  zone = var.zone
  # token = var.yc_token
}

resource "yandex_compute_instance" "vm" {
  count = 2
  name = "terraform-${count.index}"

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.0.id
    nat = true # чтобы машине был выдан внешний IP-адрес
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = file("startup.sh")
  }

  lifecycle {
    # prevent_destroy = true
    # ignore_changes = [boot_disk]
  }

}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  count = 1
  name = "subnet-${count.index}"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.${count.index+10}.0/24"]
}

# output "internal_ip_address_vm_1" {
  # value = yandex_compute_instance.vm.network_interface.0.ip_address
# }

output "external_ip_address_vm_1" {
  # value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
 value = {
   for instance in yandex_compute_instance.vm : instance.network_interface[0].nat_ip_address => instance.name
 }
}






