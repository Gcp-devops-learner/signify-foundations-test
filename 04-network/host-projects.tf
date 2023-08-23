/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {

  vpc = distinct(flatten([for i in var.host_project_vpc : [for vpc, subnet in i.create_vpc_subnets :
    { vpc_name   = vpc
      project_id = i.project_id
      subnets    = subnet
      shared_vpc = !contains(i.non_shared_vpc, vpc)
  }]]))

  firewall = distinct(flatten([for i in var.host_project_vpc : [for vpc, firewall in i.firewall :
    { vpc_name   = vpc
      project_id = i.project_id
      firewall   = firewall
  }]]))
}

module "host-project" {
  source        = "terraform-google-modules/project-factory/google"
  version       = "~> 12.0"
  for_each      = { for i in var.host_project_vpc : i.project_id => i }
  name          = each.key
  project_id    = each.key
  org_id        = var.org_id
  folder_id     = "folders/${each.value.folder_id}"
  activate_apis = each.value.activate_apis

  billing_account = var.billing_account
}


module "shared-vpc" {
  source           = "terraform-google-modules/network/google"
  version          = "~> 5.1"
  for_each         = { for i in local.vpc : "${i.project_id}=>${i.vpc_name}" => i }
  project_id       = module.host-project[each.value.project_id].project_id
  network_name     = each.value.vpc_name
  shared_vpc_host  = each.value.shared_vpc
  routing_mode     = "GLOBAL"
  subnets          = each.value.subnets
  secondary_ranges = contains(keys(var.secondary_subnet_ranges), each.value.project_id) ? contains(keys(var.secondary_subnet_ranges[each.value.project_id]), each.value.vpc_name) ? element(values(var.secondary_subnet_ranges[each.value.project_id]), 0) : {} : {}
}



module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  for_each     = { for i in local.firewall : "${i.project_id}=>${i.vpc_name}" => i }
  project_id   = module.host-project[each.value.project_id].project_id
  network_name = module.shared-vpc["${each.value.project_id}=>${each.value.vpc_name}"].network_name

  rules = each.value.firewall
}
