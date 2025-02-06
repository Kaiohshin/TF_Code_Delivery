data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "tf_docker_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    effect = "Allow"
  }
}
resource "aws_iam_role" "tf_docker_role" {
  name               = "tf_docker_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tf_docker_role.json
}
resource "aws_iam_instance_profile" "tf_docker_role" {
  name = "tf_docker_role"
  role = aws_iam_role.tf_docker_role.name
}

resource "aws_iam_role_policy_attachment" "attach_ssm_core" {
  policy_arn = data.aws_iam_policy.ssm_core.arn
  role       = aws_iam_role.tf_docker_role.name
}

#s3
data "aws_iam_policy_document" "s3_tf_docker_role_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      module.s3_bucket.s3_bucket_arn 
    ]
  }
}
resource "aws_iam_policy" "s3_tf_docker_role_policy" {
  name   = "s3_tf_docker_role_policy"
  policy = data.aws_iam_policy_document.s3_tf_docker_role_policy.json
}
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.tf_docker_role.name
  policy_arn = aws_iam_policy.s3_tf_docker_role_policy.arn
}

#ECR
data "aws_iam_policy_document" "ecr_tf_docker_role_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "ecr_tf_docker_role_policy" {
  name   = "ecr_tf_docker_role_policy"
  policy = data.aws_iam_policy_document.ecr_tf_docker_role_policy.json
}
resource "aws_iam_role_policy_attachment" "attach_ecr" {
  role       = aws_iam_role.tf_docker_role.name
  policy_arn = aws_iam_policy.ecr_tf_docker_role_policy.arn
}

#DYDB
data "aws_iam_policy_document" "dydb_tf_docker_role_policy" {
  statement {
    sid = "ListAndDescribe"
    actions = [
      "dynamodb:List*",
      "dynamodb:DescribeReservedCapacity*",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive"
    ]
    resources = ["*"]
  }
  statement {
    sid = "dockerdydb"
    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWrite*",
      "dynamodb:CreateTable",
      "dynamodb:Delete*",
      "dynamodb:Update*",
      "dynamodb:PutItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/docker_dydb"]
  }
}
resource "aws_iam_policy" "dydb_tf_docker_role_policy" {
  name   = "dydb_tf_docker_role_policy"
  policy = data.aws_iam_policy_document.dydb_tf_docker_role_policy.json
}
resource "aws_iam_role_policy_attachment" "attach_dydb" {
  role       = aws_iam_role.tf_docker_role.name
  policy_arn = aws_iam_policy.dydb_tf_docker_role_policy.arn
}
