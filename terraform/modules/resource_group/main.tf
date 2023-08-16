resource "alicloud_resource_manager_resource_group" "default" {
//  count               = var.rg_id == "" ? 1 : 0
  display_name        = var.rg_display_name
  resource_group_name = var.rg_name

  provisioner "local-exec" {
    command = "sleep 30"
    when    = destroy
  }
}
