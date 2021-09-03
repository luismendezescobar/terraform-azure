locals {
  vm_disks = {
    for x in var.additional_disks : x.name => x
  }

  blank_service_account = {
    email  = ""
    scopes = []
  }

  default_service_account = {
    email  = ""
    scopes = ["cloud-platform", "https://www.googleapis.com/auth/cloudruntimeconfig", "storage-rw"]
  }

  metadata_startup_script = var.init_script == "" ? "" : data.template_file.user_init[0].rendered

  all_service_principals = var.service_account != local.blank_service_account ? merge(var.service_account, local.default_service_account) : local.default_service_account

  default_metadata = {
    domain-join   = "true"
   # resourceowner = var.resource_owner
  }

  all_metadata = var.metadata != {} ? merge(var.metadata, local.default_metadata) : local.default_metadata

  lower_case_labels     = { for key in keys(var.instance_labels) : lower(key) => lower(var.instance_labels[key]) }
  zone                  = var.zone == "" ? "northamerica-northeast1-a" : var.zone
  instance_machine_type = var.instance_machine_type == "" ? "n1-standard-4" : var.instance_machine_type
  subnetwork_self_link  = format("projects/%s/regions/northamerica-northeast1/subnetworks/%s", var.subnetwork_project, var.subnetwork)
  int_static_ip_name = var.project_id == "uni-intraweb-dev-d09c" ? "${lower(var.instance_name)}-static-int" : join("-", ["static-int-ip", lower(var.instance_name)])
}