variable "region" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "vpc_id" {
    type = string
    default = null
    description = "in case you want to use existing vpc"
}

variable "vpc_cidr_block" {
    type = string
    default = null
    description = "only to create new vpc"
}

variable "vpc_name" {
    type = string
    default = null
    description = "only to create new vpc"
}

variable "internet_gw_name" {
    type = string
    default = null
    description = "only to create new vpc"
}

variable "route_table_id" {
    type = string
    default = null
    description = "in case you want to use existing one"
}

variable "existing_subnet" {
    description = "list of existing subnet, key=value for subnets name and id"
    type = list(object({
        Name = string
        Id = string
    }))
    default = []
}

variable "subnets" {
    description = "List of subnets to create"
    type = list(object({
        name = string
        cidr_block = string
        availability_zone = string
        map_public_ip_on_launch = optional(bool, false)
    }))
    default = []
}

variable "eks_cluster_role_policy_name" {
    type = string
    default = null
}

variable "eks_cluster_name" {
    type = string
    default = null
}

variable "eks_node_group_name" {
    type = string
    default = null
}

variable "eks_instance_type" {
    type = list(string)
    default = null
}