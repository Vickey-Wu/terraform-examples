#resource "aws_iam_role" "workernodes" {
#  name = "eks-worker-role"
#
#  assume_role_policy = jsonencode({
#    Statement = [{
#      Action = "sts:AssumeRole"
#      Effect = "Allow"
#      Principal = {
#        Service = "ec2.amazonaws.com"
#      }
#    }]
#    Version = "2012-10-17"
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.workernodes.name
#}
#
#resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.workernodes.name
#}
#
## for ec2 build docker image ecr
## resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
##  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
##  role    = aws_iam_role.workernodes.name
## }
#
#resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#  role       = aws_iam_role.workernodes.name
#}
#
#resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.workernodes.name
#}
#

resource "aws_eks_node_group" "worker-node-group-supplier" {
  #node_role_arn = aws_iam_role.workernodes.arn
  #cluster_name    = aws_eks_cluster.bcp.name
  #instance_types  = ["t3.xlarge"]
  node_role_arn   = var.eks_worker_role_arn
  cluster_name    = var.eks_cluster_name
  instance_types  = [var.eks_worker_instance_type]
  node_group_name = var.eks_node_group_supplier
  subnet_ids      = [var.private_subnet_1a, var.private_subnet_1b]
  disk_size       = 40
  #labels          = { node-group = "supplier" }
  labels = { node-group = var.eks_node_group_supplier }

  taint {
    key    = "node-group"
    value  = var.eks_node_group_supplier
    effect = "PREFER_NO_SCHEDULE"
  }

  scaling_config {
    desired_size = 0
    max_size     = 1
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = var.ec2_key_pair
    source_security_group_ids = [var.eks_worker_ssh_sg]
  }
  #depends_on = [
  #  aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
  #  aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  #  aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  #  aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore,
  #]
}

resource "aws_eks_node_group" "worker-node-group-www" {
  #node_role_arn = aws_iam_role.workernodes.arn
  #cluster_name    = aws_eks_cluster.bcp.name
  node_role_arn   = var.eks_worker_role_arn
  cluster_name    = var.eks_cluster_name
  instance_types  = [var.eks_worker_instance_type]
  node_group_name = var.eks_node_group_www
  subnet_ids      = [var.private_subnet_1a, var.private_subnet_1b]
  disk_size       = 40

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = var.ec2_key_pair
    source_security_group_ids = [var.eks_worker_ssh_sg]
  }
}
