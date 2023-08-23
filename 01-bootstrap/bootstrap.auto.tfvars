project_name = "prj-sgnfy-com-ops"

org_id = "959940203345"

parent_folder = "886461083664"

billing_account = "018E79-EA214D-06F5C0"

group_org_admins = "gcp-organization-admins@signify.com"

group_billing_admins = "gcp-billing-admins@signify.com"

default_region = "europe-west4"

sa_org_iam_permissions = [
  "roles/billing.user",
  "roles/compute.networkAdmin",
  "roles/compute.xpnAdmin",
  "roles/iam.securityAdmin",
  "roles/iam.serviceAccountAdmin",
  "roles/logging.configWriter",
  "roles/serviceusage.serviceUsageAdmin",
  "roles/orgpolicy.policyAdmin",
  "roles/resourcemanager.folderAdmin",
  "roles/resourcemanager.organizationViewer"
]
