resource "yandex_compute_instance" "vm" {
  name = var.vm_name

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
    subnet_id = var.subnet_id
    # subnet_id = yandex_vpc_subnet.subnet-1.0.id
    nat = true # чтобы машине был выдан внешний IP-адрес
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    # user-data = file("startup.sh")
  }

  lifecycle {
    # prevent_destroy = true
    # ignore_changes = [boot_disk]
  }

}

locals {
  names = [yandex_compute_instance.vm.name]
  ips   = [yandex_compute_instance.vm.network_interface.0.nat_ip_address]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("hosts.tpl", {
      names = local.names,
      addrs = local.ips,
      user = "ubuntu", 
  })
  filename = "/Users/pavelkozlov/Documents/DevOps/terragrunt/vpn/dev/hosts.ini"
}
