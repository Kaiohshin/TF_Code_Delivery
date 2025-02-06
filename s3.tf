# resource "aws_s3_bucket" "bucket" {
#   bucket = "${var.environment.name}-tf-docker-compose-test1"

#   tags = {
#     Name = "${var.environment.name}tf-docker-compose-test1"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_crypto_conf" {
#   bucket = aws_s3_bucket.bucket.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.environment.name}-tf-docker-compose-test1"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_crypto_conf" {
  bucket = module.s3_bucket.s3_bucket_id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
