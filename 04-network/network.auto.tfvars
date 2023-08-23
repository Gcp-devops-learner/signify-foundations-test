org_id = "664894405813"

billing_account = "01EC42-60DAEA-EF98C0"

host_project_vpc = [{
  project_id              =  "km1-runcloud"                      
  folder_id               = "995293380238"
  activate_apis           = ["compute.googleapis.com","logging.googleapis.com","monitoring.googleapis.com", "servicenetworking.googleapis.com"]
  non_shared_vpc          = ["vpc-hub-base"]
  vpc_private_svc_connect = []
  create_vpc_subnets = {
    "vpc-hub-base" : [{
      subnet_name           = "sb-hub-base-ewest4-1"
      subnet_ip             = "130.142.127.16/28"
      subnet_region         = "europe-west4"
      subnet_private_access = true
      },
      # {
      #   subnet_name               = "sb-prod-shared-base-1"
      #   subnet_ip                 = "10.0.13.0/22"
      #   subnet_region             = "europe-west1"
      #   subnet_private_access     = true
      #   subnet_flow_logs          = true
      #   subnet_flow_logs_sampling = "0.5"
      #   subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      #   subnet_flow_logs_interval = "INTERVAL_10_MIN"
      # }
    ]
  }
  firewall = {
    "vpc-hub-base" : [{
      name                    = "fw-allow-ingress-icmp"
      description             = "allow icmp"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "icmp"
        ports    = []
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
      }, {
      name                    = "fw-allow-ingress-intra-range"
      description             = "allow intra range"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["130.142.127.16/28"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "all"
        ports    = []
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }],
  }
  }, {
  project_id     = "service-project1-367504"
  folder_id      = "995293380238"
  activate_apis  = ["compute.googleapis.com","logging.googleapis.com","container.googleapis.com","monitoring.googleapis.com", "servicenetworking.googleapis.com"]
  non_shared_vpc = []

#vpc_private_svc_connect will create a internal reserve ip for managed services
  vpc_private_svc_connect = [{
    network_name  = "vpc-prod-shared-base"
    address_name  = "int-svc-connect"
    address_type  = "INTERNAL"
    purpose       = "VPC_PEERING"
    prefix_length = 24
    address       = "192.168.17.0"
    }
  ]
  create_vpc_subnets = {
    "vpc-prod-shared-base" : [
    # {
    #   subnet_name   = "sb-prod-shared-base-ewest4-1-lb"
    #   subnet_ip     = "130.142.127.0/29"
    #   subnet_region = "europe-west4"
    #   role          = "ACTIVE"
    #   purpose       = "REGIONAL_MANAGED_PROXY"
    #   }, 
    {
      subnet_name           = "sb-prod-shared-base-ewest4-gke-1"
      subnet_ip             = "130.142.127.32/27"
      subnet_region         = "europe-west4"
      subnet_private_access = true
    }
    ]
  }
  firewall = {
    "vpc-prod-shared-base" : [{
      name                    = "fw-allow-ingress-icmp"
      description             = "allow icmp"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "icmp"
        ports    = []
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
      }, {
      name                    = "fw-allow-ingress-intra-range"
      description             = "allow intra range"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["130.142.127.32/27","192.168.8.0/21","192.168.0.0/21"] # add "130.142.127.0/29" later when adding proxy subnet
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "all"
        ports    = []
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }],
  }
  }, {
  project_id     = "baljeetsce1"
  folder_id      = "995293380238"
  activate_apis  = ["compute.googleapis.com","logging.googleapis.com","container.googleapis.com","monitoring.googleapis.com", "servicenetworking.googleapis.com"]
  non_shared_vpc = []
  
#vpc_private_svc_connect will create a internal reserve ip for managed services
  vpc_private_svc_connect = [{
    network_name  = "vpc-nonprod-shared-base"
    address_name  = "int-svc-connect"
    address_type  = "INTERNAL"
    purpose       = "VPC_PEERING"
    prefix_length = 24
    address       = "192.168.19.0"
  }]
  create_vpc_subnets = {
    "vpc-nonprod-shared-base" : [
    #     {
    #   subnet_name   = "sb-nonprod-shared-base-ewest4-1-lb"
    #   subnet_ip     = "130.142.127.8/29"
    #   subnet_region = "europe-west4"
    #   role          = "ACTIVE"
    #   purpose       = "REGIONAL_MANAGED_PROXY"
    #   }, 
      {
      subnet_name           = "sb-nonprod-shared-base-ewest4-gke-1"
      subnet_ip             = "130.142.127.64/27"
      subnet_region         = "europe-west4"
      subnet_private_access = true
    }]
  }
  firewall = {
    "vpc-nonprod-shared-base" : [{
      name                    = "fw-allow-ingress-icmp"
      description             = "allow icmp"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "icmp"
        ports    = []
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
      }, {
      name                    = "fw-allow-ingress-intra-range"
      description             = "allow intra range"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["130.142.127.64/27","192.168.32.0/21","192.168.24.0/21"] #add "130.142.127.8/29" for proxy subnets later
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "all"
        ports    = []
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }],
  }
  }
]


secondary_subnet_ranges = {
  "service-project1-367504" : {
    "vpc-prod-shared-base" : {
      "sb-prod-shared-base-ewest4-gke-1" : [
        {
          range_name    = "pod-secondary-range"
          ip_cidr_range = "192.168.0.0/21"
          }, {
          range_name    = "svc-secondary-range"
          ip_cidr_range = "192.168.8.0/21"
      }]
    }
  },
  "baljeetsce1" : {
    "vpc-nonprod-shared-base" : {
      "sb-nonprod-shared-base-ewest4-gke-1" : [
        {
          range_name    = "pod-secondary-range"
          ip_cidr_range = "192.168.24.0/21"
          }, {
          range_name    = "svc-secondary-range"
          ip_cidr_range = "192.168.32.0/21"
      }]
    }
  }
}



router = [{
  project_id                         = "service-project1-367504"
  name                               = "cr-prod-shared-base-ewest4-cr1"
  region                             = "europe-west4"
  nat_name                           = "cn-prod-shared-base-ewest4-nat1"
  network                            = "vpc-prod-shared-base"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  subnetworks                        = []
  }, {
  project_id                         = "baljeetsce1"
  name                               = "cr-nonprod-shared-base-ewest4-cr1"
  region                             = "europe-west4"
  nat_name                           = "cn-nonprod-shared-base-ewest4-nat1"
  network                            = "vpc-nonprod-shared-base"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  subnetworks                        = []
}]



peering = [{
  network_1 = "vpc-hub-base"
  project_1 = "km1-runcloud"
  network_2 = "vpc-prod-shared-base"
  project_2 = "service-project1-367504" },
  {
    network_1 = "vpc-hub-base"
    project_1 = "km1-runcloud"
    network_2 = "vpc-nonprod-shared-base"
    project_2 = "baljeetsce1"
}]
