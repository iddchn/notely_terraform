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

variable "security_group_id" {
    description = "list of existing sgs, key=value for security groups name and id"
    type = list(object({
        Name = string
        Id = string
    }))
    default = []
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

variable "idan_sg_list" {
    description = "amp of SG to create"
    type = map(object({
        name = string
        description = string
        ingress_rules = list(object({
            from_port = number
            to_port = number
            protocol = string
            cidr_blocks = list(string)
            description = string
        }))
        egress_rules = list(object({
            from_port = number
            to_port = number
            protocol = string
            cidr_blocks = list(string)
            description = string
        }))
    }))
    default = {}
}

variable "ec2_instance_template" {
    type = object({
        name_prefix = string
        ec2_ami = string
        instance_type = string
        key_pair = string
        security_gerops_name = list(string)
        propagate_at_launch = bool
    })
    default = null
}
variable "number_of_instances" {
    type = number
    default = 1
}