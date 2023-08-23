module "cloud_router" {
  depends_on = [module.shared-vpc]
  source     = "terraform-google-modules/cloud-router/google"
  for_each   = { for i in var.router : i.name => i }
  name       = each.key
  project    = each.value.project_id
  region     = each.value.region
  network    = each.value.network
}

module "cloud-nat" {
  depends_on                         = [module.cloud_router]
  source                             = "terraform-google-modules/cloud-nat/google"
  for_each                           = { for i in var.router : "${i.name}=>${i.nat_name}" => i }
  project_id                         = each.value.project_id
  region                             = each.value.region
  router                             = each.value.name
  name                               = each.value.nat_name
  source_subnetwork_ip_ranges_to_nat = each.value.source_subnetwork_ip_ranges_to_nat
  subnetworks = [for sub in each.value.subnetworks : { name = "projects/${each.value.project_id}/regions/${each.value.region}/subnetworks/${sub.name}"
    source_ip_ranges_to_nat = sub.source_ip_ranges_to_nat
  secondary_ip_range_names = sub.secondary_ip_range_names }]
}
