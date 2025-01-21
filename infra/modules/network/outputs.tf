output "internet_gw_id" {
    value = aws_internet_gateway.idan_igw[0].id
}

output "idan_ec2_subnets_id" {
    value = local.idan_ec2_subnets_id
}

output "vpc_id" {
    value = local.vpc_id
}

output "var_subnets" {
    value = var.subnets
}