resource "aws_vpc" "idan_vpc" {
    count      = local.existing_vpc_id ? 0 : 1
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_internet_gateway" "idan_igw" {
    count = local.existing_vpc_id ? 0 : 1
    vpc_id = aws_vpc.idan_vpc[0].id
    tags = {
        Name = var.internet_gw_name
    }
}

resource "aws_route_table" "idan_rt" {
    count = local.existing_vpc_id ? 0 : 1
    vpc_id = aws_vpc.idan_vpc[0].id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.idan_igw[0].id
    }

    tags = {
        Name = "public_rout_table"
    }
}

resource "aws_subnet" "idan_subnets" {
   for_each = { for idx, subnet in var.subnets : idx => subnet }

    vpc_id = local.vpc_id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = each.value.map_public_ip_on_launch
    tags = {
        Name = each.value.name
    }
}

resource "aws_route_table_association" "idan_subnets_association" {
    for_each = { for idx, subnet_id in local.idan_ec2_subnets_id : idx => subnet_id }
    route_table_id = local.route_table_id
    subnet_id = each.value
}
