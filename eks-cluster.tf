#resource "aws_iam_role" "eks-cluster-role" {
#  name               = "eks-cluster-role"
#  path               = "/"
#  assume_role_policy = <<EOF
#{
# "Version": "2012-10-17",
# "Statement": [
#  {
#   "Effect": "Allow",
#   "Principal": {
#    "Service": "eks.amazonaws.com"
#   },
#   "Action": "sts:AssumeRole"
#  }
# ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.eks-cluster-role.name
#}
#
###resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
###  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
###  role       = aws_iam_role.eks-cluster-role.name
###}

resource "aws_eks_cluster" "bcp" {
  #role_arn = aws_iam_role.eks-cluster-role.arn
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids              = [var.private_subnet_1a, var.private_subnet_1b]
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [var.eks_cluster_sg]
  }

  #depends_on = [
  #  aws_iam_role.eks-cluster-role,
  #]
}