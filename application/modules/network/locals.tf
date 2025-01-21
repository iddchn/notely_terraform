locals {
    existing_vpc_id = var.vpc_id != null

    vpc_id = var.vpc_id != null ? var.vpc_id : aws_vpc.idan_eks_vpc[0].id

    #===========================================
    #============== subnet logic ===============
    #===========================================
    subnets_map = {
        for idx, subnet in var.subnets :
            "subnet-${idx}" => subnet
    }
    # create list of object from aws_security_group.idan_search_sg
    created_idan_subnet = [
        for subnet_key, subnet in aws_subnet.idan_eks_subnets :
        {Name = subnet.tags.Name, Id = subnet.id}
    ]
    # convert both of the list to map for merging
    input_subntes_map = { for subnet in var.existing_subnet : subnet.Name => subnet }
    created_subntes_map = { for subnet in local.created_idan_subnet : subnet.Name => subnet }
    # merge both subnets
    merge_subnet_map = merge(local.input_subntes_map, local.created_subntes_map)
    # convert the merged map of subnet back to list
    idan_subnet_full_list = [for subnet_key, subnet in local.merge_subnet_map : subnet]
    #create list of subnet ids
    idan_ec2_subnets_id = [ for subnet in local.idan_subnet_full_list : subnet.Id ]
    # #create list of subnet names
    # idan_ec2_subnets_name = [ for subnet in local.idan_subnet_full_list : subnet.name ]

    route_table_id = var.route_table_id != null ? var.route_table_id : aws_route_table.idan_eks_rt[0].id
}