variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "service_projects_map" {
  type        = map(any)
  description = "Project & Corresponding Folder ID with Host project and APIs to activate."
}


variable "standalone_projects_map" {
type = map(any)
description = "Project & Corresponding Folder ID ."
}