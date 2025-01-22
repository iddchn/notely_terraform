region = "ap-south-1"

tags = {
  Owner = "idan.cohen"
  Bootcamp = "BC22"
  Expiration_date = "01-03-25"
}

vpc_cidr_block = "10.0.0.0/16"

vpc_name = "idan_eks_vpc"

internet_gw_name = "idan_eks_igw"

subnets = [
    {name = "idan-eks-subnet-1", cidr_block = "10.0.1.0/24", availability_zone = "ap-south-1a", map_public_ip_on_launch = true},
    {name = "idan-eks-subnet-2", cidr_block = "10.0.2.0/24", availability_zone = "ap-south-1b", map_public_ip_on_launch = true}
]

eks_cluster_name = "idan-eks-cluster"

eks_node_group_name = "idan-eks-node-group"

eks_cluster_role_policy_name = "idan-eks-role-policy"

eks_instance_type = ["t3a.medium"]

eks_ebs_csi_name = "idan-eks-ebs-csi"

eks_ebs_csi_iam_policy_name = "idan-eks-ebs-csi-iam-policy"

eks_ebs_iam_role_name = "idan-eks-ebs-iam-role"