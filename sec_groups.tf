#master nodes sec_group
resource "aws_security_group" "k8s-cluster" {
  name        = "terraform-eks-k8s-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.k8s.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-k8s"
  }
}

#resource "aws_security_group_rule" "k8s-cluster-ingress-workstation-https" {
#  cidr_blocks       = [local.workstation-external-cidr]
#  description       = "Allow workstation to communicate with the cluster API Server"
#  from_port         = 443
#  protocol          = "tcp"
#  security_group_id = aws_security_group.k8s-cluster.id
#  to_port           = 443
#  type              = "ingress"
#}

#worker nodes sec_group
resource "aws_security_group" "k8s-worker-node" {
  name        = "terraform-eks-k8s-worker-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.k8s.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "terraform-eks-k8s-worker-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

resource "aws_security_group_rule" "k8s-worker-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.k8s-worker-node.id
  source_security_group_id = aws_security_group.k8s-worker-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "k8s-worker-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s-worker-node.id
  source_security_group_id = aws_security_group.k8s-cluster.id
  to_port                  = 65535
  type                     = "ingress"
 }

 resource "aws_security_group_rule" "k8s-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s-cluster.id
  source_security_group_id = aws_security_group.k8s-worker-node.id
  to_port                  = 443
  type                     = "ingress"
}
