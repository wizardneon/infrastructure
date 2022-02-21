variable "cluster-name" {
  default = "Diplom-Kubernetes-Cluster"
  type    = string
}

variable "aws_region" {
  default = "eu-west-1"
  type    = string
}

variable "k8s_bastion_node_instance_type" {
  default = "t2.micro"
  type    = string
}

variable "k8s_worker_node_instance_type" {
  default = "t2.large"
  type    = string
}

variable "k8s_bastion_node_ami" {
  default = "ami-035966e8adab4aaad"
  type    = string
}

variable "k8s_bastion_node_key_name" {
  default = "ireland"
  type    = string
}

variable "worker_nodes_desired_size" {
  default = "1"
  type    = string
}

variable "worker_nodes_max_size" {
  default = "2"
  type    = string
}

variable "worker_nodes_min_size" {
  default = "1"
  type    = string
}

variable "repo_name" {
  default = "ecr_for_images"
  type    = string
}

variable "DATABASE_NAME" {
  default = "dbname"
  type    = string
}

variable "DATABASE_USER" {
  default = "dbuser"
  type    = string
}

variable "DATABASE_PASSWORD" {
  default = "dbpassword"
  type    = string
}

variable "profile" {
  default = "wizardneon"
  type    = string
}

