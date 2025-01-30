resource "aws_iam_role" "s3-tf-docker-role" {
  name               = "s3-tf-docker-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "s3-tf-docker-role-instanceprofile" {
  name = "s3-tf-docker-role"
  role = aws_iam_role.s3-tf-docker-role.name
}

resource "aws_iam_role_policy" "s3-tf-docker-role-policy" {
  name = "s3-tf-docker-role-policy"
  role = aws_iam_role.s3-tf-docker-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:ListBucket"
            ],
            "Resource": [
              "arn:aws:s3:::tf-docker-compose-test1"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject"
            ],
            "Resource": [
              "arn:aws:s3:::tf-docker-compose-test1/*"
            ]
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "ecr-tf-docker-role-policy" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}
resource "aws_ecrpublic_repository_policy" "ecr_repo_name" {
  repository_name = aws_ecrpublic_repository.ecr_repo_name.repository_arn
  policy          = data.aws_iam_policy_document.ecr_repo_policy.json
}