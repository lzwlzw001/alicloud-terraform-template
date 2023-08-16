# Get Ram user
data "alicloud_ram_users" "ram_users" {
  name_regex = "^${var.ack_rbac_data.name}$"
  lifecycle {
    # The total count of searched ram user should equal to 1
    postcondition {
      condition     = 1 == length(self.users)
      error_message = "the total count of searched ram user should equal to 1."
    }
  }
}

resource "alicloud_ram_user_policy_attachment" "user_attach" {
  policy_name = var.ack_rbac_data.ram_policy_name
  policy_type = var.ack_rbac_data.ram_policy_type
  user_name   = data.alicloud_ram_users.ram_users.users[0].name
}

# RBAC authorization to ram users for the cluster
resource "alicloud_cs_kubernetes_permissions" "ram_user_permission" {
  uid = data.alicloud_ram_users.ram_users.users[0].id
  dynamic "permissions" {
    for_each = var.ack_rbac_data.permission_list
    content {
      cluster     = var.ack_rbac_data.cluster_id
      role_type   = permissions.value["ack_role_type"]
      role_name   = permissions.value["ack_role_name"]
      is_custom   = permissions.value["ack_custom"]
      is_ram_role = false
      namespace   = permissions.value["ack_namespace"]
    }
  }
  depends_on = [
    alicloud_ram_user_policy_attachment.user_attach
  ]
}