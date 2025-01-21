variable vpc_id {
    type = string
    default = null
}

variable "security_group_id" {
    description = "list of existing sgs, key=value for security groups name and id"
    type = list(object({
        Name = string
        Id = string
    }))
    default = []
}

variable "idan_sg_list" {
    description = "map of SG to create"
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

variable "idan_ec2_subnets" {
    type = list(string)
    default = null
}

variable "number_of_instances" {
    type = number
    default = 1
}

variable "eip_allocation_id" {
    type = string
    default = null
}