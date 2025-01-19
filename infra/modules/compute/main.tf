resource "aws_security_group" "idan_sg" {
    for_each = local.security_groups_map

    name        = each.value.name
    description = each.value.description
    vpc_id      = var.vpc_id

    dynamic "ingress" {
        for_each = each.value.ingress_rules
        content {
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
            description = ingress.value.description
        }
    }

    dynamic "egress" {
        for_each = each.value.egress_rules
        content {
            from_port   = egress.value.from_port
            to_port     = egress.value.to_port
            protocol    = egress.value.protocol
            cidr_blocks = egress.value.cidr_blocks
            description = egress.value.description
        }
    }

    tags = {
        Name = each.value.name
    }
}

# resource "aws_vpc_security_group_ingress_rule" "ingress_rule_to_sg" {
#     for_each = { for key, sg in aws_security_group.idan_sg : key => sg }
#     security_group_id = aws_security_group.idan_sg[each.key].id
#     from_port         = 0
#     to_port           = 0
#     ip_protocol       = -1
#     cidr_ipv4         = aws_security_group.idan_sg[each.key].id
#     description       = "All Traffic to sg"
# }
#
# resource "aws_vpc_security_group_ingress_rule" "idan_rule_ingress" {
#     for_each = {
#         for sg_ingress, sg in var.idan_sg_list :
#         sg_ingress => sg.ingress_rules
#     }
#     security_group_id = aws_security_group.idan_sg[each.key].id
#     from_port         = each.value.from_port
#     to_port           = each.value.to_port
#     ip_protocol       = each.value.protocol
#     cidr_ipv4         = each.value.cidr_blocks
#     description       = each.value.description
# }
#
# resource "aws_vpc_security_group_egress_rule" "idan_rule_egress" {
#     for_each = {
#         for sg_egress, sg in var.idan_sg_list :
#         sg_egress => sg.egress_rules
#     }
#     security_group_id = aws_security_group.idan_sg[each.key].id
#     from_port         = each.value.from_port
#     to_port           = each.value.to_port
#     ip_protocol       = each.value.protocol
#     cidr_ipv4         = each.value.cidr_blocks
#     description       = each.value.description
# }


resource "aws_iam_policy" "idan_iam_ecr_policy" {
    name = "idan_ecr_policy"
    description = "This policy give permissions to pull from the ECR"

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Action" : [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage"
                ],
                "Resource" : "*"
            }
        ]
    })
}

resource "aws_iam_role" "idan_iam_role" {
    name = "idan_iam_role"
    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Action" : [
                    "sts:AssumeRole"
                ],
                "Principal" : {
                    "Service" : [
                        "ec2.amazonaws.com"
                    ]
                }
            }
        ]
    })

    tags = {
        Name = "idan_iam_role"
    }
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
    role       = aws_iam_role.idan_iam_role.name
    policy_arn = aws_iam_policy.idan_iam_ecr_policy.arn
}

resource "aws_iam_instance_profile" "idan_iam_profile" {
    name = aws_iam_role.idan_iam_role.name
    role = aws_iam_role.idan_iam_role.name
}

resource "aws_launch_template" "idan_ec2" {
    name_prefix   = var.ec2_instance_template.name_prefix
    image_id      = var.ec2_instance_template.ec2_ami
    instance_type = var.ec2_instance_template.instance_type
    key_name      = var.ec2_instance_template.key_pair
    iam_instance_profile {
        arn = aws_iam_instance_profile.idan_iam_profile.arn
    }
    network_interfaces {
        security_groups             = local.idan_ec2_sg
        subnet_id = var.idan_ec2_subnets[0]
        associate_public_ip_address = true
    }
    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "${var.ec2_instance_template.name_prefix}_instance"
        }
    }
}

resource "aws_instance" "idan_jenkins_instance" {
    count = var.number_of_instances
    launch_template {
        id      = aws_launch_template.idan_ec2.id
    }

    tags = {
        Name = "${var.ec2_instance_template.name_prefix}_instance"
    }
}

# resource "aws_autoscaling_group" "idan_ec2_instances" {
#     name = "idan_idan_ec2_instances"
#     launch_template {
#         id      = aws_launch_template.idan_ec2.id
#         version = "$Latest"
#     }
#     max_size         = 5
#     min_size         = 2
#     default_cooldown = 2
#
#     vpc_zone_identifier = local.idan_ec2_subnets
#     target_group_arns = [aws_lb_target_group.alb_target_group.arn]
#
#     tag {
#         key                 = "Name"
#         value               = "${var.ec2_instance_template.name_prefix}_instance"
#         propagate_at_launch = var.ec2_instance_template.propagate_at_launch
#     }
#
#     lifecycle {
#         create_before_destroy = true
#     }
# }
#
# resource "aws_autoscaling_policy" "scale_up" {
#     autoscaling_group_name = aws_autoscaling_group.idan_ec2_instances.name
#     name                   = "scale-up-policy"
#     scaling_adjustment     = 1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 10
# }
#
# resource "aws_autoscaling_policy" "scale_down" {
#     autoscaling_group_name = aws_autoscaling_group.idan_ec2_instances.name
#     name                   = "scale_down_policy"
#     scaling_adjustment     = -1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 10
# }

