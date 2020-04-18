variable "cluster-name" {
  default = "A-Lovely-Kubernetes-Cluster"
  type    = string
}

variable "aws_region" {
  default = "eu-west-1"
  type    = string
}

variable "k8s_bastion_node_instance_type" {
  default = "t2.nano"
  type    = string
}

variable "k8s_bastion_node_ami" {
  default = "ami-035966e8adab4aaad"
  type    = string
}

variable "k8s_bastion_node_key_name" {
  default = "demo_key"
  type    = string
}
