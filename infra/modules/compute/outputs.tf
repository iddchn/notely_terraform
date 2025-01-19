output "security_group_id" {
    value = local.idan_ec2_sg
}

output "security_group_name" {
    value = local.filter_ec2_sg
}

output "iam_role_id" {
    value = aws_iam_role.idan_iam_role.id
}

output "instance_id" {
    value = aws_launch_template.idan_ec2.id
}

output "instance_name" {
    value = aws_launch_template.idan_ec2.name
}
