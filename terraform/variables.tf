variable "k8s_key_pair_name" {
    description = "kubernetes key pair name for each node server"
    type = string
}

variable "log_project_data" {
  type = object({
    name          = string
    description   = string
    tags          = map(any)
  })
}

variable "ack_data" {
  type = object({
    k8s_name                            = string
    k8s_cluster_spec                    = string
    k8s_pod_cidr                        = string
    k8s_vswitch_ids                     = list(any)
    k8s_service_cidr                    = string
    k8s_new_nat_gateway                 = bool
    k8s_load_balancer_spec              = string
    k8s_timezone                        = string
    k8s_proxy_mode                      = string
    k8s_service_account_issuer          = string
    k8s_api_audiences                   = list(any)
    k8s_is_enterprise_security_group    = bool
    k8s_deletion_protection             = bool
    k8s_audit_log_components            = list(any)
  })
}

variable "node_pool_data" {
    type = object({
      node_pool_name           = string
#      node_instance_types      = list(any)
      vswitch_ids              = list(any)
      node_pool_desired_size   = number
      node_image_type          = string
    })
}

variable "k8s_policy_name" {
    description = "kubernetes policy name will be created for this new ack"
    type = string
}


variable "k8s_cluster_addons" {
    type = list(object({
        name     = string
        config   = string
        disabled = bool
    }))
}

variable "ack_rbac_ram_user" {
  type = list(object({
    name = string
    permission_list = list(object({
      ack_role_name = string
      ack_role_type = string
      ack_namespace = optional(string, "")  # The namespace to which the permissions are scoped. This parameter is required only if you set ack_role_type to namespace.
      ack_custom    = optional(bool, false) # Specifies whether to perform a custom authorization. To perform a custom authorization, set ack_role_name to a custom cluster role
    }))
  }))

  default = []
}

variable "rg_data" {
  type = object({
    rg_id                = optional(string, "")
    resource_group_name  = string
    display_name         = string
  })
}

variable "ram_users_data" {
  type = list(object({
      name     = string
      email    = optional(string, "")
      mobile   = optional(string, "")
      force    = optional(bool, false)
  }))
}

variable "db_instances_data" {
  type = map(object({
    engine           = string
    vswitch_id       = string
    engine_version   = string
    instance_storage = string
    vpc_id           = string
    instance_type    = string
    backup_enabled   = bool
  }))
}

variable "oss_data" {
  type = list(object({
    bucket  = string
    acl     = string
  }))
}
