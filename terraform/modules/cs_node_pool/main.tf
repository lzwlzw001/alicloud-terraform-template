data "alicloud_instance_types" "instance_types_idfs_ack_r6e_2xlarge" {
  cpu_core_count       = 8
  memory_size          = 32
#  availability_zone    = "ap-southeast-1c"
  instance_type_family = "ecs.g6e"
  instance_charge_type = "PostPaid"
  kubernetes_node_role = "Worker"
}

resource "alicloud_cs_kubernetes_node_pool" "default" {
  name           = var.name
  cluster_id     = var.cluster_id
  vswitch_ids    = var.vswitch_ids
  instance_types = [data.alicloud_instance_types.instance_types_idfs_ack_r6e_2xlarge.instance_types[0].id]
  key_name       = var.key_name
  desired_size   = var.desired_size
  image_type     = var.image_type
  resource_group_id      = var.resource_group_id

  data_disks {
    category          = "cloud_essd"
    size              = 100
  }
  system_disk_category          = "cloud_essd"
  system_disk_size              = 150
}
