resource "aws_ecr_repository" "ecr_repo" {
  provider = aws.hk
  name     = "vickeywu/ecr_repo"
  # for_each = "all repos"
  # image_tag_mutability = "MUTABLE"

  # image_scanning_configuration {
  #   scan_on_push = true
  # }
}

data "aws_iam_policy_document" "allow_pull_policy" {
  statement {
    sid    = "AllowPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      # "ecr:PutImage",
      # "ecr:InitiateLayerUpload",
      # "ecr:UploadLayerPart",
      # "ecr:CompleteLayerUpload",
      # "ecr:DescribeRepositories",
      # "ecr:GetRepositoryPolicy",
      # "ecr:ListImages",
      # "ecr:DeleteRepository",
      # "ecr:BatchDeleteImage",
      # "ecr:SetRepositoryPolicy",
      # "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "allow_pull_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = data.aws_iam_policy_document.allow_pull_policy.json
}
