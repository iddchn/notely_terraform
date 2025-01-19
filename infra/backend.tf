terraform {
    backend "s3" {
    bucket = "idan-bucket-bc22"
    key = "terraform_infra.tfstate"
    region = "ap-south-1"
    encrypt = true
    dynamodb_table = "idan-terrafrom-locks-table"
  }
}