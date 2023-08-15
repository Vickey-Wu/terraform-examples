variable "region" {
  type        = string
  description = "aws default region"
  default     = "ap-east-1"
  sensitive   = false
}

variable "env_map" {
  type        = map(string)
  description = "env map var"
}
variable "env_list" {
  type        = list(string)
  description = "env list var"
}

variable "object_var" {
  type = object({
    name = string,
    tag  = string
  })
}

variable "private_subnet_1a" {
  type    = string
  default = "subnet-xxxxxx"
}

variable "private_subnet_1b" {
  type    = string
  default = "subnet-xxxxxx"
}

variable "eks_cluster_name" {
  type    = string
  default = "bcp"
}

variable "eks_node_group_www" {
  type    = string
  default = "worker-group-www"
}

variable "eks_cluster_role_arn" {
  type    = string
  default = "arn:aws:iam::xxxxxx:role/EKS-Cluster-Role"
}

variable "eks_worker_role_arn" {
  type    = string
  default = "arn:aws:iam::xxxxxxx:role/EKS-Workers-Role"
}

variable "eks_worker_instance_type" {
  type    = string
  #default = "t3.xlarge"
  default = "t3.medium"
}

variable "eks_node_group_supplier" {
  type    = string
  default = "xxxxxxx"
}

variable "eks_cluster_sg" {
  type    = string
  default = "sg-xxxxxx"
}

variable "ec2_key_pair" {
  type    = string
  default = "xxxxxx"
}

variable "eks_worker_ssh_sg" {
  type    = string
  default = "sg-xxxxxx"
}

variable "nacos_cluster_sg" {
  type    = string
  default = "sg-xxxxxx"
}

variable "nacos_cluster_acm_arn" {
  type    = string
  default = "arn:aws:acm:ap-east-1:xxxxxxxxxxxx:certificate/xxxxxxxxx"
}

variable "nacos_cluster_instance_ip" {
  type    = list(any)
  default = ["10.xxxxx", "10.xxxxx", "10.xxxxx"]
}