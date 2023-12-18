resource "random_password" "rnd" {
  length = 16
}

output "password" {
  value = random_password.rnd.result
  sensitive = true
}
