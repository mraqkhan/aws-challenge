resource "aws_s3_bucket" "pbdemo_athena_data_s3_bucket" {
  bucket        = "${var.aws_s3_bucket_name}-${terraform.workspace}"
  force_destroy = true

  tags = {
    Name        = "PB demo athena Bucket"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_s3_bucket_public_access_block" "pbdemo_athena_data_s3_bucket_block_public_access" {
  bucket = aws_s3_bucket.pbdemo_athena_data_s3_bucket.id

  block_public_acls   = true
  block_public_policy = true
}