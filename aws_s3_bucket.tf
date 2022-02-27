resource "aws_s3_bucket" "lambda_s3_bucket" {
  bucket        = "aws-challange-s3-aq-${terraform.workspace}"
  force_destroy = true

  tags = {
    Name        = "AWS-Challange-S3-Bucket"
    Environment = "${terraform.workspace}"
  }
}

# resource "aws_s3_bucket_public_access_block" "aws_s3_bucket_block_public_policy" {
#   bucket = aws_s3_bucket.lambda_s3_bucket.id

#   block_public_acls   = true
#   block_public_policy = true
# }