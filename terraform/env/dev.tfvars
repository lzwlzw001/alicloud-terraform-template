k8s_key_pair_name = "dfs-dev-k8s-key"

k8s_policy_name = "AckDfsClusterAdminAccess"

log_project_data = {
  name        = "lvmhackdev01-log"
  description = "Log store for prod k8s"
  tags = {
    "env" = "dev"
  }
}

ack_data = {
  k8s_name                         = "DFS-ICT-DEV-01-ACK"
  k8s_cluster_spec                 = "ack.pro.small"
  k8s_pod_cidr                     = "192.168.32.0/19"
  k8s_service_cidr                 = "192.168.0.0/19"
  k8s_vswitch_ids                  = ["vsw-t4ngxqq5tb45uxu7ec9u7", "vsw-t4narjtt8qrdigtcm75yr"]
  k8s_new_nat_gateway              = false
  k8s_load_balancer_spec           = "slb.s1.small"
  k8s_timezone                     = "Asia/Singapore"
  k8s_proxy_mode                   = "ipvs"
  k8s_service_account_issuer       = "kubernetes.default.svc"
  k8s_api_audiences                = ["kubernetes.default.svc"]
  k8s_is_enterprise_security_group = true
  k8s_deletion_protection          = true
  k8s_audit_log_components         = ["apiserver", "kcm", "scheduler"]
}

k8s_cluster_addons = [
  {
    "name"   = "logtail-ds",
    "config" = "{\"IngressDashboardEnabled\":\"true\",\"sls_project_name\":\"log-dfs-ack\"}",
    disabled = false
  },
  {
    "name"   = "nginx-ingress-controller",
    "config" = "{\"IngressSlbNetworkType\":\"intranet\", \"IngressSlbSpec\":\"slb.s2.small\"}",
    disabled = false
  },
  {
    "name"   = "ack-node-problem-detector",
    "config" = "{\"sls_project_name\":\"log-dfs-ack\"}",
    "disabled" : false,
  }
]

node_pool_data = {
  node_pool_name           = "default-nodepool"
#  node_instance_types      = ["ecs.g8a.2xlarge"]
  vswitch_ids              = ["vsw-t4ngxqq5tb45uxu7ec9u7", "vsw-t4narjtt8qrdigtcm75yr"]
  node_pool_desired_size   = 2
  node_image_type          = "AliyunLinux"
}

ack_rbac_ram_user = [
  {
    name = "svc_DevOps_GitHub"
    permission_list = [
      {
        ack_role_name = "admin"
        ack_role_type = "cluster"
      }
    ]
  },
]

rg_data = {
  display_name         = "RG-DEV-TF"
  resource_group_name  = "RG-DEV-TF"
}


ram_users_data = [
  {
    name   = "svc_DevOps_GitHub"
    email  = "svc_DevOps_GitHub@dfs.com"
    mobile = ""
    force  = false
  },
  # Add more RAM user data as needed
]

db_instances_data = {
  dfs_mysql_instance: {
    engine            = "MySQL"
    vswitch_id        = "vsw-t4ngxqq5tb45uxu7ec9u7"
    engine_version    = "8.0"
    instance_storage  = "300"
    vpc_id            = "vpc-t4napjc0bfgikn31tv39q"
    instance_type     = "mysql.n8.xlarge.xc"
    backup_enabled    = true
  }
}

oss_data = [
  {
    bucket = "alsidfsoctdev03-oss"
    acl    = "private"
  }
]
