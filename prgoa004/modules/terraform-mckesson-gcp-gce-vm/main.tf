
data "template_file" "user_init" {
  count    = var.init_script == "" ? 0 : 1
  template = file(var.init_script)
}


data "google_compute_image" "image" {
  count   = var.image_name == "" ? 0 : 1
  family  = var.image_name
  project = var.region == "us-central1" || var.region == "us-west1" || var.region == "us-east4" || var.region == "northamerica-northeast1" ? "core-imagesna-prod-b432" : (var.region == "europe-west2" || var.region == "europe-west3" ? "core-imageseu-prod-0058" : null) # Images project: Availbe options are: US:core-imagesna-prod-b432 EU: core-imageseu-prod-0058
}

/******************************************
 Creating additional disks for VM
 *****************************************/
resource "google_compute_disk" "gce_machine_disks" {
  for_each = local.vm_disks

  project = var.project_id
  name    = join("-", [lower(var.instance_name), each.value.name])
  type    = each.value.disk_type
  zone    = local.zone
  labels  = local.lower_case_labels
  size    = each.value.disk_size_gb
  snapshot = each.value.snapshot 
}

/******************************************
 Current Multi-disk vm
 *****************************************/
resource "google_compute_instance" "gce_machine" {
  project      = var.project_id
  name         = lower(var.instance_name)
  machine_type = local.instance_machine_type
  zone         = local.zone
  labels       = local.lower_case_labels
  tags         = var.instance_tags
  description  = var.instance_description

  metadata_startup_script = local.metadata_startup_script

  metadata = local.all_metadata

  allow_stopping_for_update = true

  boot_disk {
    auto_delete = var.auto_delete
  
  
    initialize_params {
      image = var.source_image != "" ? var.source_image : data.google_compute_image.image[0].self_link
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  dynamic "attached_disk" {
    for_each = local.vm_disks
    iterator = disk
    content {
      source      = lookup(google_compute_disk.gce_machine_disks[disk.value.name], "id", null)
      device_name = disk.value.name
    }
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = var.static_internal_ip == "" ? "" : google_compute_address.static_internal_address[0].address

    dynamic "alias_ip_range" {
      for_each = var.alias_ip_range
      content {
        ip_cidr_range = alias_ip_range.value
      }
    }
  }

  dynamic "service_account" {
    for_each = [local.all_service_principals]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }
}

/******************************************
 Creating Static Internal IP 
 *****************************************/
resource "google_compute_address" "static_internal_address" {
  count        = var.static_internal_ip == "" ? 0 : 1
  name         = local.int_static_ip_name #join("-", ["static-int-ip", lower(var.instance_name)])
  subnetwork   = local.subnetwork_self_link
  address_type = "INTERNAL"
  address      = var.static_internal_ip
  project      = var.project_id
  region       = var.region
}