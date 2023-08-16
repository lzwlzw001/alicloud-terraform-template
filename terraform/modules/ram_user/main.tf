data "alicloud_ram_users" "ram_users" {
  name_regex = "^${var.name}$"

}

resource "alicloud_ram_user" "user" {
  count = length(data.alicloud_ram_users.ram_users.users) == 0 ? 1 : 0
  
  name   = var.name
  email  = var.email
  mobile = var.mobile
  force  = var.force
}