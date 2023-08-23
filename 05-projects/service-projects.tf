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
/******************************************
  Service project creation
 *****************************************/


module "service-projects" {
  source  = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version = "~> 14.2"

  for_each                    = var.service_projects_map
  name                        = each.key
  project_id                  = each.key
  org_id                      = var.org_id
  folder_id                   = "folders/${each.value.parent}"
  shared_vpc                  = each.value.host
  billing_account             = var.billing_account
 // activate_apis               = each.value.apis
  disable_dependent_services  = true
  disable_services_on_destroy = true
}


module "standalone-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  for_each   = var.standalone_projects_map
  name       = each.key
  project_id = each.key
  org_id     = var.org_id
  folder_id  = "folders/${each.value.parent}"
 // activate_apis = each.value.apis
  billing_account = var.billing_account

  
}
