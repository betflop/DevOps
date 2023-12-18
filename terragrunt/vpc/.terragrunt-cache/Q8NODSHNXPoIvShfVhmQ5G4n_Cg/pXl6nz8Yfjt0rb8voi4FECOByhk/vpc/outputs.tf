output "subnets" {
 value = { for subnet in yandex_vpc_subnet.subnet : subnet.name => subnet.id }
 description = "The IDs of the subnets"
}
