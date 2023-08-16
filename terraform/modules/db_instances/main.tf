resource "alicloud_db_instance" "instance" {
  engine           = var.db_instance_data.engine
  engine_version   = var.db_instance_data.engine_version
  instance_type    = var.db_instance_data.instance_type
  instance_storage = var.db_instance_data.instance_storage
  vswitch_id       = var.db_instance_data.vswitch_id
  vpc_id           = var.db_instance_data.vpc_id
  zone_id = "ap-southeast-1c"
  zone_id_slave_a = "ap-southeast-1b"
}

resource "alicloud_rds_account" "user" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "dfs_mysql"
  account_password = "xnmMkb$M7MYKs4$W"
}

# Logical backup_method seems not to be supported at the time of inital config.
# Description of possible choices: https://help.aliyun.com/document_detail/96772.html
# Recovering: https://help.aliyun.com/document_detail/96776.htm
resource "alicloud_rds_backup" "instance_backup" {
  count = var.db_instance_data.backup_enabled  ? 1 : 0

  db_instance_id  = alicloud_db_instance.instance.id
  backup_method   = "Snapshot"
  backup_strategy = "instance"
  backup_type     = "FullBackup"
}

resource "alicloud_db_backup_policy" "instance_backup_policy" {
  count = var.db_instance_data.backup_enabled ? 1 : 0

  instance_id             = alicloud_db_instance.instance.id
  backup_interval         = 360 # Backup every 6 hours
  backup_retention_period = 30  # Keep backups for 30 days
  enable_backup_log       = false
}