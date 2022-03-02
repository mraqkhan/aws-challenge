resource "aws_iam_role" "aws_challange_lambda_assume_role" {
  name               = "AWSChallangeLambdaAssumeRole-${terraform.workspace}"
  assume_role_policy = file("roles_and_policies/lambda_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "lambda_s3_put_obj_policy_attachment" {
  role       = aws_iam_role.aws_challange_lambda_assume_role.name
  policy_arn = aws_iam_policy.lambda_s3_put_obj_policy.arn
}

resource "aws_iam_role_policy_attachment" "aws_lambda_basis_executio_role_attachment" {
  role       = aws_iam_role.aws_challange_lambda_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "template_file" "lambda_s3_put_obj_policy_template" {
  template = file("roles_and_policies/lambda_put_object_policy.json.tpl")
  vars = {
    bucket = "${aws_s3_bucket.aws_lambda_s3_bucket.arn}"
  }
}

resource "aws_iam_policy" "lambda_s3_put_obj_policy" {
  name   = "AWSChallangeS3PutObjectPolicy-${terraform.workspace}"
  policy = data.template_file.lambda_s3_put_obj_policy_template.rendered
}