locals {
  vpc_private_svc_connect = distinct(flatten([for i in var.host_project_vpc : [for svc in i.vpc_private_svc_connect :
    { network_name  = svc.network_name
      project_id    = i.project_id
      address_name  = svc.address_name
      address_type  = svc.address_type
      purpose       = svc.purpose
      prefix_length = svc.prefix_length
      address       = svc.address

  }]]))

}


resource "google_compute_global_address" "address" {
  for_each      = { for i in local.vpc_private_svc_connect : "${i.project_id}-${i.network_name}-${i.address_name}" => i }
  provider      = google-beta
  name          = each.value.address_name
  purpose       = each.value.purpose
  address_type  = each.value.address_type
  prefix_length = each.value.prefix_length
  address       = each.value.address
  project       = each.value.project_id
  network       = module.shared-vpc["${each.value.project_id}=>${each.value.network_name}"].network_name
}


# Establish VPC network peering connection using the reserved address range
resource "google_service_networking_connection" "private_vpc_connection_development" {
  for_each                = { for i in local.vpc_private_svc_connect : "${i.project_id}-${i.network_name}-service-network-connect" => i }
  provider                = google-beta
  network                 = module.shared-vpc["${each.value.project_id}=>${each.value.network_name}"].network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.address["${each.value.project_id}-${each.value.network_name}-${each.value.address_name}"].name]
}

#Update Routes Configuration in Peering Connection
resource "google_compute_network_peering_routes_config" "peering_routes_development" {
  for_each             = { for i in local.vpc_private_svc_connect : "${i.project_id}-${i.network_name}-service-network-connect" => i }
  peering              = google_service_networking_connection.private_vpc_connection_development["${each.value.project_id}-${each.value.network_name}-service-network-connect"].peering
  network              = module.shared-vpc["${each.value.project_id}=>${each.value.network_name}"].network_name
  project              = each.value.project_id
  import_custom_routes = true
  export_custom_routes = true
  depends_on           = [google_service_networking_connection.private_vpc_connection_development]
}

module "gcloud" {
  source                = "terraform-google-modules/gcloud/google"
  version               = "~> 3.1.0"
  for_each              = { for i in local.vpc_private_svc_connect : "${i.project_id}-${i.network_name}-service-network-connect" => i}
  module_depends_on     = [google_compute_network_peering_routes_config.peering_routes_development]
  platform              = "linux"
  create_cmd_entrypoint = "gcloud"
  create_cmd_body       = "compute networks peerings update ${google_service_networking_connection.private_vpc_connection_development["${each.value.project_id}-${each.value.network_name}-service-network-connect"].peering} --network ${each.value.network_name} --export-subnet-routes-with-public-ip --import-subnet-routes-with-public-ip  --project ${each.value.project_id}"
}
