#EKS Cluster
resource "aws_iam_role" "idan_eks_cluster_role" {
  name = var.eks_cluster_role_policy_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = var.eks_cluster_role_policy_name
  }
}

resource "aws_iam_role_policy_attachment" "idan_eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.idan_eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "idan_eks_vpc_resource_policy_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.idan_eks_cluster_role.name
}

resource "aws_eks_cluster" "idan_eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.idan_eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids[*]
  }

  tags = {
    Name = var.eks_cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.idan_eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.idan_eks_vpc_resource_policy_controller
  ]
}

#Node Group
resource "aws_iam_role" "idan_eks_node_role" {
  name = var.eks_node_group_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = var.eks_node_group_name
  }
}

resource "aws_iam_role_policy_attachment" "idan_node_group_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.idan_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "idan_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.idan_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "idan_ec2_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.idan_eks_node_role.name
}

resource "aws_eks_node_group" "idan_eks_node_group" {
  cluster_name    = aws_eks_cluster.idan_eks_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.idan_eks_node_role.arn

  subnet_ids = var.subnet_ids[*]
  version = aws_eks_cluster.idan_eks_cluster.version

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  instance_types = var.eks_instance_type

  depends_on = [
    aws_iam_role_policy_attachment.idan_node_group_policy,
    aws_iam_role_policy_attachment.idan_cni_policy,
    aws_iam_role_policy_attachment.idan_ec2_container_registry_policy
  ]

  tags = {
    Name = var.eks_node_group_name
  }
}

resource "aws_eks_addon" "idan_ebs_csi" {
  cluster_name = aws_eks_cluster.idan_eks_cluster.name
  addon_name   = var.eks_ebs_csi_name

  depends_on = [
    aws_eks_node_group.idan_eks_node_group
  ]

  tags = {
    Name = var.eks_ebs_csi_name
  }
}

resource "aws_iam_policy" "idan_ebs_csi_policy" {
  name        = var.eks_ebs_csi_iam_policy_name
  description = "Policy for EBS CSI driver to manage EBS volumes."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:CreateSnapshot",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DeleteSnapshot",
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "idan_ebs_csi_role" {
  name = var.eks_ebs_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "eks-ebs-csi-role"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy_attachment" {
  role       = aws_iam_role.idan_ebs_csi_role.name
  policy_arn = aws_iam_policy.idan_ebs_csi_policy.arn
}

