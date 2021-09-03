project_id         = "playground-s-11-be851f0c"
network_project_id = "playground-s-11-be851f0c"
region             = "northamerica-northeast1"
vpc_name           = "default"
subnetwork         = "default"
deployment_target  = "production"

/******************************************
for Intranet-extranet-serviceweb app server VM instance group
*******************************************/
org             = "mck"
location        = "uni"
bu_code         = "mcn"
finance_bu_code = "mcn"
purpose         = "a"  # web
env             = "pr" # prod

instance_description = "Intranet-extranet-serviceweb Prod Instance"
instance_tags        = ["fw-rdp", "fw-https", "fw-gcp-hc-all", "fw-graylog", "northamerica-northeast1-internet-default", "fw-ansible"]
source_image         = "https://www.googleapis.com/compute/v1/projects/windows-cloud/global/images/windows-server-2016-dc-v20210810"                        
domain               = "medisna"
resource_owner       = "edmq36v"
bap_id               = "bap10803_bap10804_bap10812"

extra_front_ends = {
  "extranet" = "ALL"
  "others"   = "ALL"
}

webserver_vm_info = {
  "prgoa004" = {
    zone               = "northamerica-northeast1-a"
    instance_type      = "e2-medium "
    disk_size_gb       = 50
    static_internal_ip = "10.162.0.10"
    loadbalancer       = "intranetextranet"
    #loadbalancer       = ""
    additional_disks = [{
      disk_size_gb = 10
      disk_type    = "pd-standard"
      name         = "d-drive"
      snapshot     = ""
      },
      {
        disk_size_gb = 20
        disk_type    = "pd-standard"
        name         = "t-drive"
        snapshot     = ""
      }
    ]
  },

}
