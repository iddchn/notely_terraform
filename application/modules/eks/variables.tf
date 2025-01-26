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

variable "eks_version" {
    type = string
    default = null
}

variable "mongodb_secret" {
    type = string
    default = null
}

variable "app_namespace" {
    type = string
    default = null
}

variable "secret_manager_serviceaccount_name" {
    type = string
    default = null
}

variable "eks_vpc_cni_name" {
    type = string
    default = null
}