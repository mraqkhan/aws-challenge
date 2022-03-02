resource "aws_s3_bucket" "aws_lambda_s3_bucket" {
  bucket        = "${var.aws_s3_bucket_name}-${terraform.workspace}"
  force_destroy = true

  tags = {
    Name        = "AWS-Challange-S3-Bucket"
    Environment = "${terraform.workspace}"
  }
}
