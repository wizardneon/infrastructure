locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.k8s-worker-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.k8s.endpoint}
    certificate-authority-data: ${aws_eks_cluster.k8s.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${var.cluster-name}"
KUBECONFIG
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
  sensitive   = true
}

output "kubeconfig" {
  value = local.kubeconfig
  sensitive   = true
}

output "bastion_eip" {
  value = aws_eip.bastion_eip.public_ip
}
output "RDS_endpoint" {
  value =aws_db_instance.postgres.endpoint
}
output "repository_url" {
  description = "The URL of the repository."
  value = aws_ecr_repository.ecr_for_images.repository_url
}
