locals {
  instance_group_name  = var.env == "d" ? "dvgo${var.purpose}" : "${var.env}go${var.purpose}"
  project_name         = substr(var.project_id, 0, -5)
  sql_instance_name    = "${var.org}-${var.location}-${var.bu_code}-intranet-extranet-serviceweb-${var.env}"
  network_self_link    = "projects/${var.network_project_id}/global/networks/${var.vpc_name}"
  subnetwork_self_link = "projects/${var.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"

  metadata = {
    domain         = var.domain
    resource_owner = var.resource_owner
  }

  instance_labels = {
    environment           = var.env
    bap_id                = var.bap_id
    business-unit         = var.bu_code
    finance-business-unit = var.finance_bu_code
    display-name          = local.instance_group_name
    project-name          = local.project_name
  }

  loadbalancers = distinct([for vm in var.webserver_vm_info : lookup(vm, "loadbalancer", "")])
  loadbalancer_map = { for loadbalancer in local.loadbalancers : loadbalancer => {
    vms = [for key in keys(var.webserver_vm_info) : key if var.webserver_vm_info[key].loadbalancer == loadbalancer]
    }
  }

}


output "output_main_instance_group_name" {
  value=local.instance_group_name
}
output "output_main_project_name" {
  value=local.project_name
}
output "output_main_loadbalancers" {
  value=local.loadbalancers
}
output "output_main_loadbalancers_map" {
  value=local.loadbalancer_map
}



module "webserver_vm_instance" {
  for_each              = var.webserver_vm_info
  source                = "./modules/terraform-mckesson-gcp-gce-vm"
  project_id            = var.project_id
  region                = var.region
  subnetwork            = var.subnetwork
  subnetwork_project    = var.network_project_id
  instance_name         = each.key
  image_name            = var.image_name
  source_image          = var.source_image
  additional_disks      = each.value.additional_disks
  metadata              = local.metadata
  zone                  = each.value.zone
  instance_machine_type = each.value.instance_type
  disk_size_gb          = each.value.disk_size_gb
  instance_tags         = var.instance_tags
  instance_labels       = merge(var.instance_labels, local.instance_labels)
  init_script           = ""
  instance_description  = var.instance_description
  static_internal_ip    = each.value.static_internal_ip
}