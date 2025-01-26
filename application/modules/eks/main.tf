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
  version  = var.eks_version

  vpc_config {
    subnet_ids = var.subnet_ids[*]
  }

  tags = {
    Name = var.eks_cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.idan_eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.idan_eks_vpc_resource_policy_controller,
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

resource "aws_iam_role_policy_attachment" "idan_ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
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
    aws_iam_role_policy_attachment.idan_ec2_container_registry_policy,
  ]

  tags = {
    Name = var.eks_node_group_name
  }
}

data "aws_eks_cluster_auth" "idan_eks_cluster" {
  name = aws_eks_cluster.idan_eks_cluster.name
}

resource "aws_eks_addon" "idan_ebs_csi" {
  cluster_name = aws_eks_cluster.idan_eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"
  depends_on = [
    aws_eks_node_group.idan_eks_node_group
  ]

  service_account_role_arn = aws_iam_role.idan_ebs_csi_role.arn

  tags = {
    Name = var.eks_ebs_csi_name
  }
}

resource "aws_eks_addon" "idan_vpc_cni" {
  cluster_name = aws_eks_cluster.idan_eks_cluster.name
  addon_name   = "vpc-cni"
  depends_on = [
    aws_eks_node_group.idan_eks_node_group
  ]


  tags = {
    Name = var.eks_vpc_cni_name
  }
}

resource "aws_iam_role" "vpc_cni_role" {
  name               = "AmazonEKSVPCCNIRole"
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_policy.json
}

data "aws_iam_policy_document" "vpc_cni_assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy_attachment" "vpc_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  roles      = [aws_iam_role.vpc_cni_role.name]
  name       = "AmazonEKSVPCCNIRole"
}


data "tls_certificate" "oidc" {
  url = aws_eks_cluster.idan_eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "idan_ebs_csi_role" {
  name = "idan-ebs-csi-driver-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume_role.json
}

data "aws_iam_policy_document" "ebs_csi_driver_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.idan_oidc_provider.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.idan_oidc_provider.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.idan_oidc_provider.url}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

  }
}

resource "aws_iam_policy_attachment" "idan_ebs_csi_policy_attachment" {
  name = "idan-ebs-csi-driver-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  roles      = [aws_iam_role.idan_ebs_csi_role.name]
}

resource "aws_iam_openid_connect_provider" "idan_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.idan_eks_cluster.identity.0.oidc.0.issuer
}

resource "kubernetes_service_account" "ebs_csi_sa" {
  metadata {
    name      = "ebs-csi-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.idan_ebs_csi_role.arn
    }
  }
}

resource "aws_iam_policy" "idan_secrets_manager_policy" {
  name        = "SecretsManagerAccessPolicy"
  description = "Policy to allow access to Secrets Manager secret dynamically"
  policy = data.aws_iam_policy_document.idan_secrets_manager_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "idan_secretsmanager_attachment" {
  policy_arn = aws_iam_policy.idan_secrets_manager_policy.arn
  role       = aws_iam_role.idan_eks_secret_manager_role.name
}

# Secrets Manager Role

data "aws_iam_policy_document" "idan_secrets_manager_policy_doc" {
  statement {
    sid    = "AllowGetSecretValue"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.mongodb_secret
    ]
  }
}

resource "aws_iam_role" "idan_eks_secret_manager_role" {
  name = "idan-eks-secret-manager-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.idan_oidc_provider.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${aws_iam_openid_connect_provider.idan_oidc_provider.url}:sub" : "system:serviceaccount:${var.app_namespace}:${var.secret_manager_serviceaccount_name}"
          }
        }
      }
    ]
  })
}
