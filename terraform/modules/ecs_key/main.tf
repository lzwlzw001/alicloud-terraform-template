resource "alicloud_ecs_key_pair" "default" {
  key_pair_name = var.k8s_key_pair_name
}