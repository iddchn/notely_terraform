output "idan_eks_igw" {
    value = module.network.idan_eks_igw
}

output "idan_ec2_subnets_id" {
    value = module.network.idan_ec2_subnets_id
}

output "vpc_id" {
    value = module.network.vpc_id
}


output "cluster_id" {
    value = module.eks.cluster_id
}

output "node_group_id" {
    value = module.eks.node_group_id
}

output "idan_eks_rt" {
    value = module.network.idan_eks_rt
}

output "eks_cluster_role_arn" {
  value = module.eks.eks_cluster_role_arn
}

output "idan_eks_secret_manager_role" {
  value = module.eks.idan_eks_secret_manager_role
}