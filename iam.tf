resource "aws_iam_role" "tf_docker_role" {
  name               = "tf_docker_role"
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

resource "aws_iam_role_policy_attachment" "test_attach" {
  policy_arn = data.aws_iam_policy.ssm_core.arn
  role       = aws_iam_role.tf_docker_role.name
}

resource "aws_iam_instance_profile" "tf_docker_role" {
  name = "tf_docker_role"
  role = aws_iam_role.tf_docker_role.name
}

resource "aws_iam_role_policy" "s3_tf_docker_role_policy" {
  name   = "s3_tf_docker_role_policy"
  role   = aws_iam_role.tf_docker_role.id
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

resource "aws_iam_role_policy" "ecr_tf_docker_role_policy" {
  name   = "ecr_tf_docker_role_policy"
  role   = aws_iam_role.tf_docker_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
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
            ],
            "Resource": [
              "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "dydb_tf_docker_role_policy" {
  name   = "dydb_tf_docker_role_policy"
  role   = aws_iam_role.tf_docker_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAndDescribe",
            "Effect": "Allow",
            "Action": [
                "dynamodb:List*",
                "dynamodb:DescribeReservedCapacity*",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeTimeToLive"
            ],
            "Resource": "*"
        },
        {
            "Sid": "dockerdydb",
            "Effect": "Allow",
            "Action": [
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
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/docker_dydb"
        }
    ]
}
EOF
}
