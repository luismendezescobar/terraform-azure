output "name" {
  value       = google_compute_instance.gce_machine.name
  description = "Name of the VM created via this module"
}

output "self_link" {
  value       = google_compute_instance.gce_machine.self_link
  description = "Self link of the Virtual machine created via this module."
}

output "zone" {
  value       = google_compute_instance.gce_machine.zone
  description = "Zone the instance was deployed to."
}