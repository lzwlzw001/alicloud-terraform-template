resource "alicloud_db_database" "database" {
  instance_id = var.instance_id
  name        = var.database_name
}