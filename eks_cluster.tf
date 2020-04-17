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

resource "aws_eks_cluster" "k8s" {
  name     = var.cluster-name
  role_arn = aws_iam_role.k8s-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.k8s-cluster.id]
    subnet_ids         = aws_subnet.k8s[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSServicePolicy,
  ]
}
#worker_nodes

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

resource "aws_eks_node_group" "k8s" {
  cluster_name    = aws_eks_cluster.k8s.name
  node_group_name = "k8s"
  node_role_arn   = aws_iam_role.k8s-worker-node.arn
  subnet_ids      = aws_subnet.k8s[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8s-worker-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8s-worker-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8s-worker-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

#bastion_node
