variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
}


variable "host_project_vpc" {
  type = list(object({
    folder_id      = string
    project_id     = string
    activate_apis  = list(string)
    non_shared_vpc = list(string)
    vpc_private_svc_connect = list(object({
      network_name  = string
      address_name  = string
      address_type  = string
      purpose       = string
      prefix_length = number
      address       = string
    }))
    create_vpc_subnets = map(list(map(string)))
    firewall = map(list(object({
      name                    = string
      description             = string
      direction               = string
      priority                = number
      ranges                  = list(string)
      source_tags             = list(string)
      source_service_accounts = list(string)
      target_tags             = list(string)
      target_service_accounts = list(string)
      allow = list(object({
        protocol = string
        ports    = list(string)
      }))
      deny = list(object({
        protocol = string
        ports    = list(string)
      }))
      log_config = object({
        metadata = string
      })
    })))
  }))
  description = "The list of non-prod subnets being created"
  default     = []
}

variable "secondary_subnet_ranges" {
  type        = map(map(map(list(object({ range_name = string, ip_cidr_range = string })))))
  description = "The list of non-prod secondary ranges being created"
  default     = {}
}




variable "router" {
  type = list(object({
    name                               = string
    nat_name                           = string
    network                            = string
    region                             = string
    project_id                         = string
    source_subnetwork_ip_ranges_to_nat = string #ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS
    subnetworks = list(object({
      name                     = string
      source_ip_ranges_to_nat  = list(string) #ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE
      secondary_ip_range_names = list(string)
    }))
  }))
}


variable "peering" {
  type = list(object({
    network_1 = string
    project_1 = string
    network_2 = string
    project_2 = string
  }))
  default = []
}
