resource "yandex_vpc_network" "network" {
  for_each = toset(var.networks)
  name = each.value
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = toset(var.networks)
  name = "${each.value}---${var.subnet_name}"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.network[each.key].id
  # network_id = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

