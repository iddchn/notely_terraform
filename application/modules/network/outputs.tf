output "idan_eks_igw" {
    value = aws_internet_gateway.idan_eks_igw[0].id
}

output "idan_ec2_subnets_id" {
    value = local.idan_ec2_subnets_id
}

output "vpc_id" {
    value = local.vpc_id
}

output "idan_eks_rt" {
    value = aws_route_table.idan_eks_rt[0].id
}