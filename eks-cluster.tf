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

## enalbe oidc
data "tls_certificate" "tls_cert" {
  url = aws_eks_cluster.bcp.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.tls_cert.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.tls_cert.url
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
      type        = "Federated"
    }
  }
}

#resource "aws_iam_role" "example" {
#  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
#  name               = "example"
#}

## eks addon
#resource "aws_eks_addon" "aws-ebs-csi-driver" {
#  cluster_name = aws_eks_cluster.bcp.name
#  addon_name   = "aws-ebs-csi-driver"
#}
#resource "aws_eks_addon" "aws-efs-csi-driver" {
#  cluster_name = aws_eks_cluster.bcp.name
#  addon_name   = "aws-efs-csi-driver"
#}
