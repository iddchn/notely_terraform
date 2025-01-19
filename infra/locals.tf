# locals {
#     existing_vpc_id = var.vpc_id != null
#
#     vpc_id = var.vpc_id != null ? var.vpc_id : aws_vpc.idan_vpc[0].id
#
#     #===========================================
#     #============== subnet logic ===============
#     #===========================================
#     subnets_map = {
#         for idx, subnet in var.subnets :
#             "subnet-${idx}" => subnet
#     }
#     # create list of object from aws_security_group.idan_search_sg
#     created_idan_subnet = [
#         for subnet_key, subnet in aws_subnet.idan_subnets :
#         {Name = subnet.tags.Name, Id = subnet.id}
#     ]
#     # convert both of the list to map for merging
#     input_subntes_map = { for subnet in var.existing_subnet : subnet.Name => subnet }
#     created_subntes_map = { for subnet in local.created_idan_subnet : subnet.Name => subnet }
#     # merge both subnets
#     merge_subnet_map = merge(local.input_subntes_map, local.created_subntes_map)
#     # convert the merged map of sg back to list
#     idan_subnet_full_list = [for subnet_key, subnet in local.merge_subnet_map : subnet]
#
#     idan_ec2_subnets = [ for subnet in local.idan_subnet_full_list : subnet.Id ]
#
#     route_table_id = var.route_table_id != null ? var.route_table_id : aws_route_table.idan_rt[0].id
#
#     #===========================================
#     #========== security groups logic ==========
#     #===========================================
#     security_groups_map = {
#         for idx, sg in var.idan_sg_list :
#         "idan-gs-${idx}" => sg
#     }
#     # create list of object from aws_security_group.idan_sg
#     created_idan_sg = [
#         for sg_key, sg in aws_security_group.idan_sg :
#             { Name = sg.name, Id = sg.id }
#     ]
#     # convert both of the list to map for merging
#     input_sgs_map = { for sg in var.security_group_id : sg.Name => sg }
#     created_sgs_map = { for sg in local.created_idan_sg : sg.Name => sg }
#     # merge both sg
#     merged_idan_sg_map = merge(local.input_sgs_map, local.created_sgs_map)
#     # convert the merged map of sg back to list
#     idan_sg_full_list = [ for sg_key, sg in local.merged_idan_sg_map : sg ]
#
#     # select the relevant sg for the ec2
#     filter_ec2_sg = [
#         for sg in local.idan_sg_full_list :
#             sg if contains(var.ec2_instance_template.security_gerops_name, sg.Name)
#     ]
#     #select only Ids
#     idan_ec2_sg = [ for sg in local.filter_ec2_sg : sg.Id ]
#     #===========================================
# }