resource "aws_iam_role" "tf_docker_role" {
  name = "tf_docker_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "tf_docker_role" {
  name = "tf_docker_role"
  role = aws_iam_role.tf_docker_role.name
}
resource "aws_iam_role_policy_attachment" "attach_ssm_core" {
  policy_arn = data.aws_iam_policy.ssm_core.arn
  role       = aws_iam_role.tf_docker_role.name
}

# S3
resource "aws_iam_role_policy" "s3_tf_docker_role_policy" {
  name = "s3_tf_docker_role_policy"
  role = aws_iam_role.tf_docker_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::dev-tf-docker-compose-test1"
      },
    ]
  })
}

# ECR
resource "aws_iam_role_policy" "ecr_tf_docker_role_policy" {
  name = "ecr_tf_docker_role_policy"
  role = aws_iam_role.tf_docker_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
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
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# DYDB
resource "aws_iam_role_policy" "dydb_tf_docker_role_policy" {
  name = "dydb_tf_docker_role_policy"
  role = aws_iam_role.tf_docker_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:List*",
          "dynamodb:DescribeReservedCapacity*",
          "dynamodb:DescribeLimits",
          "dynamodb:DescribeTimeToLive"
        ]
        Effect   = "Allow"
        Sid      = "ListAndDescribe"
        Resource = "*"
      },
      {
        Action = [
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
        Effect   = "Allow"
        Sid      = "dockerdydb"
        Resource = "arn:aws:dynamodb:*:*:table/docker_dydb"
      }
    ]
  })
}
