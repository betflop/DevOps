
provider "helm" {
 kubernetes {
   config_path = "~/.kube/config"
 }
}

resource "helm_release" "nginx_ingress" {
 name      = "nginx-ingress"
 repository = "https://charts.helm.sh/stable"
 chart     = "nginx-ingress"
 namespace = "kube-system"
}

