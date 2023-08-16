//variable "engine" {
//  description = "the type of RDS database"
//  default = "PostgreSQL"
//}
//
//#VSwitch variables, use specific one
//variable "vswitch_id" {
//  description = "The vswitch id used to launch one or more instances."
//  default     = "vsw-uf60odevjwsw2lq7ni2sl"
//}
//
//variable "engine_version" {
//  description = "database version"
//  default = "13.0"
//}
//
//#the storage size of the database
//variable "instance_storage" {
//  default = "20"
//}
//
//variable "vpc_id" {
//  description = "specific the vpc you want to use"
//  default = "vpc-uf68665qz3f1y5u0mxhl0"
//}
//
//variable "instance_type" {
//  default = "pg.n2.2c.2m"
//}

variable "db_instance_data" {}