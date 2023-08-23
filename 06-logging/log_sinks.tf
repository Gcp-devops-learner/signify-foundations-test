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
  main_logs_filter = <<EOF
    logName: /logs/cloudaudit.googleapis.com%2Factivity OR
    logName: /logs/cloudaudit.googleapis.com%2Fsystem_event OR
    logName: /logs/cloudaudit.googleapis.com%2Fdata_access OR
    logName: /logs/compute.googleapis.com%2Fvpc_flows OR
    logName: /logs/compute.googleapis.com%2Ffirewall OR
    logName: /logs/cloudaudit.googleapis.com%2Faccess_transparency
EOF
  all_logs_filter  = ""

  log_export = distinct(flatten([for k, v in var.log_sink : [for val in v.parent_resource_id : { resource_id = val, resource_type = v.parent_resource_type, project_id = k }]]))
}



module "storage_destination" {
  source                        = "terraform-google-modules/log-export/google//modules/logbucket"
  version                       = "~> 7.4.1"
  for_each                      = var.log_sink
  project_id                    = each.key
  name                          = "sgnfy-gcp-digital-bkt-${each.key}-logs"
  location                      = each.value.location
  retention_days                = each.value.retention_days
  grant_write_permission_on_bkt = false
  log_sink_writer_identity      = null
}


module "log_export_to_storage" {
  for_each             = { for i in local.log_export : i.resource_id => i }
  source               = "terraform-google-modules/log-export/google"
  version              = "~> 7.3.0"
  destination_uri      = module.storage_destination[each.value.project_id].destination_uri
  filter               = local.all_logs_filter
  log_sink_name        = "sink-logging-bkt-${each.value.resource_id}"
  parent_resource_id   = each.value.resource_id
  parent_resource_type = each.value.resource_type
  include_children     = true
}


resource "google_project_iam_member" "logbucket_sink_member" {
  for_each = { for i in local.log_export : i.resource_id => i }
  project  = each.value.project_id
  role     = "roles/logging.bucketWriter"
  member   = module.log_export_to_storage[each.key].writer_identity
}


