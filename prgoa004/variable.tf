variable "region" {
  description = " The name of the region where the resources are going to be deployed"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "vpc network name"
  type        = string
  default     = ""
}

variable "subnetwork" {
  description = "subnet name"
  type        = string
  default     = ""
}

variable "init_script" {
  description = "Path to the user provided script file to be used to bootstrap the image. No need to included shebang at the beginning. File must exist! If not providing one then point to an empty file."
  type        = string
  default     = "./user-init/init.ps1"
}

variable "project_id" {
  description = "the project in which the resources are going to reside"
  type        = string
  default     = ""
}

variable "network_project_id" {
  description = "project id of the shared vpc network"
  type        = string
  default     = ""
}

variable "deployment_target" {
  description = "Describes the McKesson GCP Environment where the deployment will occur. Accepted values are sandbox, non-production, and production. Defaults to non-production."
  type        = string
  default     = "non-production"
}

variable "bap_id" {
  description = "bap id of the application"
  type        = string
  default     = ""
}

/******************************************
for resource naming
*******************************************/

variable "env" {
  description = "the environment where the ressources are going to be deployed"
  type        = string
  default     = ""
}

variable "purpose" {
  description = "The purpose of the VM"
  type        = string
  default     = ""
}

variable "org" {
  description = "The abbriviation of the org e.g mck"
  type        = string
  default     = ""
}

variable "location" {
  description = "The location where the resource came from "
  type        = string
  default     = ""
}

variable "bu_code" {
  description = "Short abbrivation of the business unit"
  type        = string
  default     = ""
}

variable "finance_bu_code" {
  description = "Short abbrivation of the financial business unit"
  type        = string
  default     = ""
}

/**********************************************
for Intranet-extranet-serviceweb app server VM instance template
***********************************************/

variable "instance_tags" {
  description = "vm instance tags for firewall rules"
  type        = list(string)
}

variable "instance_description" {
  description = "A brief description of the purpose/use of the template being created."
  type        = string
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 100
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  type        = bool
  default     = false
}

variable "webserver_vm_info" {
  description = "Contain object of vm name and additional disks"
  type = map(object({
    zone               = string
    instance_type      = string
    disk_size_gb       = number
    static_internal_ip = string
    loadbalancer       = string
    additional_disks = list(object({
      name         = string
      disk_size_gb = number
      disk_type    = string
      snapshot     = string
    }))
  }))

  default = {}
}

variable "backend_vm_info" {
  description = "Contain object of vm name and additional disks"
  type = map(object({
    zone               = string
    instance_type      = string
    disk_size_gb       = number
    static_internal_ip = string
    loadbalancer       = string
    additional_disks = list(object({
      name         = string
      disk_size_gb = number
      disk_type    = string
      snapshot     = string
    }))
  }))

  default = {}
}

variable "image_name" {
  description = "the image family to be used for the vm instances"
  type        = string
  default     = ""
}

variable "source_image" {
  description = "The Full path of the image to be used."
  type        = string
  default     = ""
}

variable "domain" {
  description = "the domain the vm instances are going to join"
  type        = string
  default     = ""
}

variable "resource_owner" {
  description = "Resource owners sID"
  type        = string
  default     = ""
}

variable "instance_labels" {
  type = map(string)
  default = {
    application-name  = "Intranet-extranet-serviceweb"
    application-owner = "paul_tagl"
    business-owner    = "mohamad_tamim"
    bap               = ""
    technical-owner   = "jean-francois_berard"
  }
}

/**************************************************
for Intranet-extranet-serviceweb Cloud SQL instance
***************************************************/
variable "cloudsql_name" {
  description = "Name of the cloud sql instance"
  type        = string
  default     = ""
}

variable "cloudsql_disk_size" {
  description = "The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  type        = string
  default     = "25"
}

variable "cloudsql_net_write_timeout" {
  description = "see documentation"
  type        = string
  default     = "240"
}

variable "private_network" {
  description = "Self_link of the private VPC network the cloud sql is going to attach to "
  type        = string
  default     = "https://www.googleapis.com/compute/v1/projects/net-vpc-nonprod-318a/global/networks/vpc-core-nonprod"
}

variable "instance_tier" {
  description = "CloudSQL Instance size"
  type        = string
  #default     = ""
}

variable "availability_type" {
  description = "High availability setting"
  type        = string
  default     = ""
}

variable "root_password" {
  description = "Mysql password for the root user. If not set, a random one will be generated and available in the root_password output variable."
  type        = string
  default     = ""
}

/**********************************
for Intranet-extranet-serviceweb db
***********************************/

variable "cloudsql_db_name" {
  description = "CloudSQL database name"
  type        = string
  default     = ""
}

variable "user_name" {
  description = "CloudSQL user"
  type        = string
  default     = "intranet-sql-user"
}

variable "user_password" {
  description = "cloud user password"
  type        = string
  default     = ""
}

variable "db_version" {
  description = "Database version"
  type        = string
  default     = "MYSQL_5_7"
}

variable "database_flags" {
  description = "Database custom flags"
  type        = list(map(string))
  default = [
    {
      name  = "local_infile"
      value = "off"
    }
  ]
}

variable "backup_configuration" {
  description = "Database backup configuration"
  type        = map(string)
  default = {
    binary_log_enabled             = true
    enabled                        = true
    location                       = "northamerica-northeast1"
    point_in_time_recovery_enabled = false
    start_time                     = "22:00"
  }
}

variable "maintenance_window" {
  description = "Database MX configuration"
  type        = map(string)
  default = {
    day          = 5
    hour         = 5
    update_track = "stable"
  }
}

variable "require_ssl" {
  description = "Database requires ssl or not"
  type        = bool
  default     = true
}
/***********************************
# Intranet-extranet-serviceweb Unmanaged Instance group
************************************/
variable "named_port" {
  description = "Only packets addressed to ports in the specified range will be forwarded to target. If empty, all packets will be forwarded."
  type = list(object({
    name = string
    port = string
  }))
  default = []
}

variable "frontend_name" {
  description = "The name of the forwarding rule, concatinated with the instance group name, so if ppgoa is sent, it will be ppgoa-backend-service"
  type        = string
  default     = "forwarding-rule"
}

variable "health_check" {
  description = "type of health check to perform. eg. TCP or HTTP"
  type        = map
  default = {
    type                = "tcp"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    check_interval_sec  = 5
    timeout_sec         = 3
    port_specification  = "USE_FIXED_PORT"
    initial_delay_sec   = 600
  }
}

variable "extra_front_ends" {
  description = "The front ends for the other extranet and other hostnames"
  type        = map
  default     = {}
}