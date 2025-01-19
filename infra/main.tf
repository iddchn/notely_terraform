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

module "compute" {
    source = "./modules/compute"
    vpc_id = module.network.vpc_id
    security_group_id = var.security_group_id
    idan_sg_list = var.idan_sg_list
    ec2_instance_template = var.ec2_instance_template
    idan_ec2_subnets = module.network.idan_ec2_subnets_id
}