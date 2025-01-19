terraform {
    backend "s3" {
    bucket = var.s3_bucket
    key = var.s3_state_dir
    region = var.region
    encrypt = true
    dynamodb_table = var.dynamodb_table
  }
}