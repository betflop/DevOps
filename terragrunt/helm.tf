
  provider "helm" {
    kubernetes {
      config_path = "~/.kube/config"
    }
  }

  data "helm_repository" "stable" {
    name = "stable"
    url = "https://charts.helm.sh/stable"
  }

  resource "helm_release" "nginx_ingress" {
    name    = "nginx-ingress"
    repository = data.helm_repository.stable.metadata[0].name
    chart   = "nginx-ingress"
    namespace = "kube-system"
  }
