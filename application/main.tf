module "network" {
    source = "./modules/network"
    vpc_id = var.vpc_id
    vpc_cidr_block = var.vpc_cidr_block
    vpc_name = var.vpc_name
    internet_gw_name = var.internet_gw_name
    existing_subnet = var.existing_subnet
    subnets = var.subnets
    route_table_id = var.route_table_id
}

module "eks" {
    source = "./modules/eks"
    subnet_ids = module.network.idan_ec2_subnets_id
    eks_cluster_name = var.eks_cluster_name
    eks_node_group_name = var.eks_node_group_name
    eks_cluster_role_policy_name = var.eks_cluster_role_policy_name
    eks_instance_type = var.eks_instance_type
}