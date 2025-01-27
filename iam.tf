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