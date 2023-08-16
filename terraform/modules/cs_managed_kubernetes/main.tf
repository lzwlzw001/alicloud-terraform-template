resource "alicloud_cs_managed_kubernetes" "default" {
  
  name               = var.name
  count              = var.cluster_count
  cluster_spec       = var.cluster_spec
  pod_cidr           = var.pod_cidr
  worker_vswitch_ids = var.worker_vswitch_ids
  service_cidr       = var.service_cidr

  new_nat_gateway        = var.new_nat_gateway
  load_balancer_spec     = var.load_balancer_spec
  timezone               = var.timezone
  proxy_mode             = var.proxy_mode
  service_account_issuer = var.service_account_issuer
  api_audiences          = var.api_audiences
  resource_group_id      = var.resource_group_id
  is_enterprise_security_group = var.is_enterprise_security_group
  deletion_protection          = var.deletion_protection
  control_plane_log_components = var.control_plane_log_components
  
  dynamic "addons" {
      for_each = var.cluster_addons
      content {
        name   = lookup(addons.value, "name", var.cluster_addons)
        config = lookup(addons.value, "config", var.cluster_addons)
      }
  }

}
