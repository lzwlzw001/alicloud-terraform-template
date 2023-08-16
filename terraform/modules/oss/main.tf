resource "alicloud_oss_bucket" "default" {
  bucket = var.bucket
  acl    = var.acl
}

// upload file or content to bucket instance if needed
//resource "alicloud_oss_bucket_object" "default" {
//  bucket = alicloud_oss_bucket.default.bucket
//  key    = var.oss_data.key
//  source = "./main.tf"
//}