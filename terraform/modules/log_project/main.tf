resource "alicloud_log_project" "default" {
  name        = var.name
  description = var.description
  tags        = var.tags
}