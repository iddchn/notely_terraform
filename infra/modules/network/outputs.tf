output "internet_gw_id" {
    value = aws_internet_gateway.idan_igw[0].id
}

# output "subnets_name" {
#     value = local.idan_ec2_subnets_name
# }

output "idan_ec2_subnets_id" {
    value = local.idan_ec2_subnets_id
}

output "vpc_id" {
    value = local.vpc_id
}

# output "subnet_IDs" {
#     value = aws_subnet.idan_subnets[*].id
# }

output "var_subnets" {
    value = var.subnets
}