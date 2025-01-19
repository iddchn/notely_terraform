region = "ap-south-1"

tags = {
  Owner = "idan.cohen"
  Bootcamp = "BC22"
  Expiration_date = "01-03-25"
}

vpc_cidr_block = "10.0.0.0/16"

vpc_name = "idan_terraform_vpc"

internet_gw_name = "idan_terraform_igw"

subnets = [
    {name = "idan-notely-subnet-1", cidr_block = "10.0.1.0/24", availability_zone = "ap-south-1a", map_public_ip_on_launch = true},
    {name = "idan-notely-subnet-2", cidr_block = "10.0.2.0/24", availability_zone = "ap-south-1b", map_public_ip_on_launch = true}
]

ec2_instance_template = {
    name_prefix = "idan_jenkins"
    ec2_ami = "ami-04e5769982aa583ed"
    instance_type = "t3a.medium"
    key_pair = "idan.cohen"
    security_gerops_name = ["idan_jenkins_sg"]
    propagate_at_launch = true
}

idan_sg_list = {
    idan_jenkins_sg = {
        name        = "idan_jenkins_sg"
        description = "idan_jenkins_sg"
        ingress_rules = [
            {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["79.183.236.190/32"]
                description = "Allow all traffic from my ip"
            },
            {
                from_port   = 8080
                to_port     = 8080
                protocol    = "tcp"
                cidr_blocks = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20"]
                description = "Allow github webhooks"
            }
        ]
        egress_rules = [
            {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow all traffic"
            }
        ]
    }
}