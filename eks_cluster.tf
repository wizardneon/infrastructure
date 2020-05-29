# EKS cluster

resource "aws_eks_cluster" "k8s" {
  name     = var.cluster-name
  role_arn = aws_iam_role.k8s-cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids = [aws_security_group.k8s-cluster.id]
    subnet_ids         = aws_subnet.k8s[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSServicePolicy,
  ]
}

#master_nodes
resource "aws_iam_role" "k8s-cluster" {
  name = "terraform-eks-k8s-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8s-cluster.name
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.k8s-cluster.name
}

#worker_nodes
resource "aws_eks_node_group" "k8s" {
  cluster_name    = aws_eks_cluster.k8s.name
  node_group_name = "k8s"
  node_role_arn   = aws_iam_role.k8s-worker-node.arn
  subnet_ids      = aws_subnet.k8s[*].id

  scaling_config {
    desired_size = var.worker_nodes_desired_size
    max_size     = var.worker_nodes_max_size
    min_size     = var.worker_nodes_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8s-worker-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8s-worker-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8s-worker-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_iam_role" "k8s-worker-node" {
  name = "terraform-eks-k8s-worker-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8s-worker-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8s-worker-node.name
}

resource "aws_iam_role_policy_attachment" "k8s-worker-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8s-worker-node.name
}

resource "aws_iam_role_policy_attachment" "k8s-worker-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8s-worker-node.name
}

#k8s_bastion_node
resource "aws_instance" "k8s_bastion_node" {

  ami                     = var.k8s_bastion_node_ami
  instance_type           = var.k8s_bastion_node_instance_type
  key_name                = var.k8s_bastion_node_key_name
  subnet_id               = aws_subnet.k8s[0].id
  vpc_security_group_ids  = [aws_security_group.k8s-bastion-node.id]
  tags = {
    Name = "k8s_bastion_node"
  }
}
#elastic_ip for Bastion node
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.k8s_bastion_node.id
  vpc      = true
}

resource "aws_iam_role" "k8s_bastion_node" {
  name = "k8s_bastion_node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8s_bastion_node-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.k8s_bastion_node.name
}

# OIDC
data "external" "thumb" {
  program = [ "./get_thumbprint.sh", var.aws_region ]
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumb.result.thumbprint]
  url             = aws_eks_cluster.k8s.identity.0.oidc.0.issuer
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["sts.amazonaws.com"]
#      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = ["${aws_iam_openid_connect_provider.oidc.arn}"]
      type        = "Federated"
    }
  }
}
