locals {
  reverse_peering = [for i in var.peering : {
    network_1 = i.network_2
    project_1 = i.project_2
    network_2 = i.network_1
  project_2 = i.project_1 }]
  peering = concat(var.peering, local.reverse_peering)
}


resource "google_compute_network_peering" "network-peering" {
  provider             = google-beta
  for_each             = { for i in local.peering : "${i.network_1}=>${i.network_2}" => i }
  name                 = "${each.value.network_1}-${each.value.network_2}-peering"
  network              = module.shared-vpc["${each.value.project_1}=>${each.value.network_1}"].network_self_link
  peer_network         = module.shared-vpc["${each.value.project_2}=>${each.value.network_2}"].network_self_link
  export_custom_routes = true
  import_custom_routes = true

  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true

}
