output "cluster_id" {
  value = aws_eks_cluster.idan_eks_cluster.id
}

output "node_group_id" {
  value = aws_eks_node_group.idan_eks_node_group.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.idan_eks_cluster.endpoint
}

output "cluster_ca_certificate" {
    value = aws_eks_cluster.idan_eks_cluster.certificate_authority[0].data
}

output "eks_token" {
  value = data.aws_eks_cluster_auth.idan_eks_cluster.token
}

output "eks_cluster_name" {
  value = aws_eks_cluster.idan_eks_cluster.name
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.idan_eks_cluster_role.arn
}

output "idan_eks_secret_manager_role" {
  value = aws_iam_role.idan_eks_secret_manager_role.arn
}