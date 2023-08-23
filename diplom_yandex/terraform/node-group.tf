resource "yandex_kubernetes_node_group" "testgroup123" {
  cluster_id = yandex_kubernetes_cluster.test2.id
  name       = "testgroup123"
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
  }
  scale_policy {
    fixed_scale {
      size = 1
    }   
  }
}
