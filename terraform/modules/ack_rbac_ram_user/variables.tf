variable "ack_rbac_data" {
  type = object({
    name            = string # ram user name
    cluster_id      = string
    ram_policy_name = string
    ram_policy_type = string
    permission_list = optional(list(object({
      ack_role_name = string                # admin, ops, dev, restricted and the custom cluster roles.if the ack_role_type is namespace, then only dev, restricted and custom can be used
      ack_role_type = string                # cluster, namespace
      ack_namespace = optional(string, "")  # The namespace to which the permissions are scoped. This parameter is required only if you set ack_role_type to namespace.
      ack_custom    = optional(bool, false) # Specifies whether to perform a custom authorization. To perform a custom authorization, set ack_role_name to a custom cluster role
    })), [])
  })
}