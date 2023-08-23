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
  organization_id = var.parent_folder != "" ? null : var.org_id
  folder_id       = var.parent_folder != "" ? var.parent_folder : null
  policy_for      = var.parent_folder != "" ? "folder" : "organization"
}

/******************************************
  Compute org policies
*******************************************/

# module "org_disable_nested_virtualization" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/compute.disableNestedVirtualization"
# }

# module "org_disable_serial_port_access" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/compute.disableSerialPortAccess"
# }

# module "org_compute_disable_guest_attributes_access" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/compute.disableGuestAttributesAccess"
# }

module "org_vm_external_ip_access" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  enforce         = "true"
  constraint      = "constraints/compute.vmExternalIpAccess"
}

module "org_skip_default_network" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.skipDefaultNetworkCreation"
}

# module "org_shared_vpc_lien_removal" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/compute.restrictXpnProjectLienRemoval"
# }

# module "org_shared_require_os_login" {
#   source          = "terraform-google-modules/org-policy/google"
#   count           = var.enable_os_login_policy ? 1 : 0
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/compute.requireOsLogin"
# }

/******************************************
  Cloud SQL
*******************************************/

# module "org_cloudsql_external_ip_access" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/sql.restrictPublicIp"
# }

/******************************************
  IAM
*******************************************/

module "org_domain_restricted_sharing" {
  source           = "terraform-google-modules/org-policy/google//modules/domain_restricted_sharing"
  version          = "~> 3.0"
  organization_id  = local.organization_id
  folder_id        = local.folder_id
  policy_for       = local.policy_for
  domains_to_allow = var.domains_to_allow
}


# module "org_disable_sa_key_creation" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/iam.disableServiceAccountKeyCreation"
# }

# module "org_disable_sa_key_upload" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/iam.disableServiceAccountKeyUpload"
# }

# module "org_disable_automatic_iam_grants_on_default_service_accounts" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
# }

/******************************************
  Storage
*******************************************/

# module "org_enforce_bucket_level_access" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/storage.uniformBucketLevelAccess"
# }

# module "org_enforce_public_access_prevention" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/storage.publicAccessPrevention"
# }

# module "org_domain_restricted_contacts" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "list"
#   enforce         = "true"
#   constraint      = "constraints/essentialcontacts.allowedContactDomains"
# }

# module "org_restrict_auth_nw_for_cloud_sql" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/sql.restrictAuthorizedNetworks"
# }

# module "org_restrict_protocal_forwarding_for_ip" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "list"
#   enforce         = "true"
#   constraint      = "constraints/compute.restrictProtocolForwardingCreationForTypes"
# }

# module "org_internal_dns_setting_for_new_projects_to_zone_only" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/compute.setNewProjectDefaultToZonalDNSOnly"
# }

# module "org_disable_external_ipv6_usage" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.policy_for
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/compute.disableVpcExternalIpv6"
# }
