output "public_ip_address_ad" {
  value = "${azurerm_public_ip.static.ip_address}"
}
