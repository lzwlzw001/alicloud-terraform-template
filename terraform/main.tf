terraform {
  backend "oss" {
    prefix = "terraform/state"
  }
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.208.0"
    }
  }
}

locals {
  product_name       = "DFS"
  primary_database   = "lvmhdfs01-mys"
}

module "ecs_key" {
    source = "./modules/ecs_key"

    k8s_key_pair_name = var.k8s_key_pair_name
}

# for kubernetes cluster log store
module "log_project_default" {
    source = "./modules/log_project"

    name        = var.log_project_data.name
    tags        = var.log_project_data.tags
    description = var.log_project_data.description
}

module "managed_resource_group" {
  source = "./modules/resource_group"
  rg_id             = var.rg_data.rg_id == "" ? 1 : 0
  rg_display_name   = var.rg_data.display_name
  rg_name           = var.rg_data.resource_group_name

}

module "oss" {
  source = "./modules/oss"

  for_each = {for od in var.oss_data : od.bucket => od}
  bucket = each.key
  acl    = each.value.acl
}


module "cs_managed_kubernetes" {
  source = "./modules/cs_managed_kubernetes"

  depends_on = [
    module.ecs_key,
    module.log_project_default
  ]

  name               = var.ack_data.k8s_name
  cluster_count      = 1
  cluster_spec       = var.ack_data.k8s_cluster_spec
  pod_cidr           = var.ack_data.k8s_pod_cidr
  worker_vswitch_ids = var.ack_data.k8s_vswitch_ids
  service_cidr       = var.ack_data.k8s_service_cidr

  new_nat_gateway        = var.ack_data.k8s_new_nat_gateway
  load_balancer_spec     = var.ack_data.k8s_load_balancer_spec
  timezone               = var.ack_data.k8s_timezone
  proxy_mode             = var.ack_data.k8s_proxy_mode
  service_account_issuer = var.ack_data.k8s_service_account_issuer
  api_audiences          = var.ack_data.k8s_api_audiences
  resource_group_id            = var.rg_data.rg_id == "" ? join("", module.managed_resource_group[*].rs_id) : var.rg_data.rg_id
  is_enterprise_security_group = var.ack_data.k8s_is_enterprise_security_group
  deletion_protection          = var.ack_data.k8s_deletion_protection
  control_plane_log_components = var.ack_data.k8s_audit_log_components
  cluster_addons               = var.k8s_cluster_addons
}

module "cs_node_pool" {
  source = "./modules/cs_node_pool"

  name           = var.node_pool_data.node_pool_name
  cluster_id     = module.cs_managed_kubernetes.id
#  instance_types = var.node_pool_data.node_instance_types
  vswitch_ids    = var.node_pool_data.vswitch_ids
  key_name       = module.ecs_key.key_name
  desired_size   = var.node_pool_data.node_pool_desired_size
  image_type     = var.node_pool_data.node_image_type
  resource_group_id = var.rg_data.rg_id == "" ? join("", module.managed_resource_group[*].rs_id) : var.rg_data.rg_id
}


resource "alicloud_ram_policy" "policy" {
  policy_name     = var.k8s_policy_name
  policy_document = <<EOF
  {
    "Statement": [
      {
        "Action": [
          "cs:*",
          "cs:*"
        ],
        "Effect": "Allow",
        "Resource": [
          "acs:cs:*:*:cluster/${module.cs_managed_kubernetes.id}"
        ]
      }
    ],
    "Version": "1"
  }
  EOF
  description     = "policy for cluster"
  force           = true
}

module "ram_users" {
  for_each = { for ru in var.ram_users_data : ru.name => ru }

  source = "./modules/ram_user"

  name   = each.key
  email  = each.value.email
  mobile = each.value.mobile
  force  = each.value.force
}

module "ack_rbac_ram_user" {
  for_each = { for ramuser in var.ack_rbac_ram_user : ramuser.name => ramuser }
  source   = "./modules/ack_rbac_ram_user"
  ack_rbac_data = {
    name            = each.key
    cluster_id      = module.cs_managed_kubernetes.id
    ram_policy_name = alicloud_ram_policy.policy.name
    ram_policy_type = alicloud_ram_policy.policy.type
    permission_list = each.value.permission_list
  }
}

module "ali_db_instance" {
  source = "./modules/db_instances"
  for_each = var.db_instances_data

  db_instance_data = each.value
}

module "platform_db" {
  source = "./modules/mysql_db"

  depends_on = [
    module.ali_db_instance
  ]

  for_each = module.ali_db_instance
  instance_id   = each.value.resource_id
  database_name = local.primary_database
}
