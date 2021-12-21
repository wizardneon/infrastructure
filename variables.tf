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
  default = "1"
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
# define docker image for build stage
variable "build_image" {
  default = "aws/codebuild/docker:18.09.0"
}
variable "build_spec" {
  default = "buildspec/build.yml"
}
# define docker image for deploy stage
variable "deploy_image" {
  default = "shawnxlw/ide"
}
# define build spec for deploy stage
variable "deploy_spec" {
  default = "buildspec/deploy.yml"
}
# define default git branch
variable "default_branch" {
  default = "master"
}
variable "database_name" {
  
}  
variable "database_user" {
 
}  
variable "database_password" {
 
}

