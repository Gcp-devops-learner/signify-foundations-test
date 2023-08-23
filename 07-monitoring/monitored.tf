resource "google_monitoring_monitored_project" "primary" {
  for_each      = toset(flatten([for k, v in var.monitor_scope : [for m in v : "${k}=>${m}"]]))
  metrics_scope = split("=>", each.value).0
  name          = split("=>", each.value).1
}
