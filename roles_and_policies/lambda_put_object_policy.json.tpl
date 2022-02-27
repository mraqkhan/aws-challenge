{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPutObject",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:PutObjectVersionAcl"
            ],
            "Resource": [
                "${bucket}/*"
            ]
        }
    ]
}