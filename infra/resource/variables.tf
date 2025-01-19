variable "region" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "s3_bucket" {
    type = string
    default = null
}

variable "s3_state_dir" {
    type = string
    default = null
}

variable "dynamodb_table" {
    type = string
    default = null
}