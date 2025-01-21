output "cluster_id" {
  value = aws_eks_cluster.idan_eks_cluster.id
}

output "node_group_id" {
  value = aws_eks_node_group.idan_eks_node_group.id
}