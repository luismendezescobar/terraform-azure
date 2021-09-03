variable "project_id" {
  type        = string
  description = "DR project ID that the VPC resides in."
}

variable "instance_labels" {
  type = map(string)
  default = {
    environment         = "prod"
    business_unit       = "canada"
    chargeback_category = "dc"
  }
  description = "Map of labels for project."
}

variable "region" {
  type        = string
  description = "The region to be deployed."
}

variable "zone" {
  type        = string
  description = "This must be passed to the module"
}

variable "subnetwork" {
  type        = string
  description = "Name or self link subnetwork."
}

variable "subnetwork_project" {
  type        = string
  description = "project id of the shared vpc."
}

variable "alias_ip_range" {
  type        = list(string)
  description = "List of Alias IPs to apply to the instance."
  default     = []
}

variable "instance_name" {
  type        = string
  description = "VM names type of the appliance"
}

variable "instance_tags" {
  type        = list(string)
  description = "List of tags network tags to additoinally apply to the instance."
}

variable "instance_description" {
  description = "A brief description of the purpose/use of the template being created."
  type        = string
}

variable "instance_machine_type" {
  type        = string
  description = "Machine type of the appliance"
}

variable "init_script" {
  description = "Path to the user provided script file to be used to bootstrap the image. No need to included shebang at the beginning. File must exist! If not providing one then point to an empty file."
  type        = string
}

variable "static_internal_ip" {
  description = "Static internal ip address for the instance"
  type        = string
  default     = ""
}

#######
# disk
#######

variable "image_name" {
  description = "The CORE image name to be used as the base of this template. Default image is set for Windows Server 2016"
  type        = string
  default     = "coreimages-win2016"
  # NA Images can be found using: https://confluence.mckesson.com:8443/display/OC/GCP+Core+Images+-+North+America
  # EU Images can be found using: https://confluence.mckesson.com:8443/display/OC/GCP+Core+Images+-+Europe
}

variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = ""
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  type        = string
  default     = "pd-standard"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 25
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  type        = bool
  default     = false
}


variable "additional_disks" {
  description = "List of maps of additional disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#disk_name"
  type = list(object({
    name         = string
    disk_size_gb = number
    disk_type    = string
    snapshot     = string
  }))
  default = []
}

###########
# metadata
###########
variable "resource_owner" {
  description = "Resource owners sID"
  type        = string
  default     = ""
}

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

##################
# service_account
##################

variable "service_account" {
  default = {
    email  = ""
    scopes = []
  }
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}