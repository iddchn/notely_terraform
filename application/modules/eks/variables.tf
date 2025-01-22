variable "eks_cluster_role_policy_name" {
    type = string
    default = null
}

variable "eks_cluster_name" {
    type = string
    default = null
}

variable "subnet_ids" {
    type = list(string)
    default = []
}

variable "eks_node_group_name" {
    type = string
    default = null
}

variable "eks_instance_type" {
    type = list(string)
    default = null
}

variable "eks_ebs_csi_name" {
    type = string
    default = null
}

variable "eks_ebs_csi_iam_policy_name" {
    type = string
    default = null
}

variable "eks_ebs_iam_role_name" {
    type = string
    default = null
}