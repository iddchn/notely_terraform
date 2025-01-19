output "vpc_id" {
    value = module.network.vpc_id
}

output "internet_gw_id" {
    value = module.network.internet_gw_id
}

output "subnet_ids" {
    value = module.network.idan_ec2_subnets_id
}

output "security_group_id" {
    value = module.compute.security_group_id
}

output "security_group_name" {
    value = module.compute.security_group_name
}

output "iam_role_id" {
    value = module.compute.iam_role_id
}

output "instance_id" {
    value = module.compute.instance_id
}

output "instance_name" {
    value = module.compute.instance_name
}

# output "subnet_map" {
#     value = module.network.subnet_map
# }

# output "var_subnets" {
#     value = module.network.var_subnets
# }
