"""
Test cases for aws_lambda.py
"""
from unittest import mock
import unittest
import os
import sys
import json
import boto3
from moto import mock_s3


sys.path.insert(0, "../handler")
from aws_lambda import *


@mock_s3
class TestAWSLambda(unittest.TestCase):
    """
    Unittest Test case class
    """

    mock_s3 = mock_s3()
    mock_json_data = {
        "places": [
            {
                "city": "a",
                "countryCode": "DE",
                "id": 73274,
                "lat": 50.9996751,
                "lon": 6.9832425,
                "name": "Penny",
                "partnerId": "544",
                "placeId": "33300576",
                "street": "Einsteinstrasse 2-6",
                "zipCode": "51061",
            },
            {
                "city": "b",
                "countryCode": "DE",
                "id": 146620,
                "lat": 50.9170352,
                "lon": 6.9064691,
                "name": "REWE",
                "partnerId": "413",
                "placeId": "43655817",
                "street": "Hermeskeiler Str. 18",
                "zipCode": "50935",
            },
        ],
        "version": 0,
    }
    mock_sorted_json_data = {
        "places": [
            {
                "city": "b",
                "countryCode": "DE",
                "id": 146620,
                "lat": 50.9170352,
                "lon": 6.9064691,
                "name": "REWE",
                "partnerId": "413",
                "placeId": "43655817",
                "street": "Hermeskeiler Str. 18",
                "zipCode": "50935",
            },
            {
                "city": "a",
                "countryCode": "DE",
                "id": 73274,
                "lat": 50.9996751,
                "lon": 6.9832425,
                "name": "Penny",
                "partnerId": "544",
                "placeId": "33300576",
                "street": "Einsteinstrasse 2-6",
                "zipCode": "51061",
            },
        ],
        "version": 0,
    }

    def setUp(self):
        self.mock_s3.start()
        self.env_patcher = mock.patch.dict(
            os.environ,
            {
                "API_URL": "http://localhost",
                "S3_Bucket": "aws-challange-bucket",
                "S3_Object": "aws-challange-object",
            },
        )
        self.env_patcher.start()

        s3_bucket = os.environ["S3_Bucket"]

        # run the file which uploads to S3
        s3_resource = boto3.resource("s3")

        # create a test bucket
        bucket = s3_resource.Bucket(s3_bucket)
        bucket.create()

    def tearDown(self):
        self.mock_s3.stop()
        self.env_patcher.stop()

    def test_set_log_level(self):
        """
        Test case for set_log_level
        """
        with mock.patch.dict(os.environ, {"Environment": "dev"}):
            log_level = set_log_level()
        self.assertEqual(log_level, logging.DEBUG)

        with mock.patch.dict(os.environ, {"Environment": "staging"}):
            log_level = set_log_level()
        self.assertEqual(log_level, logging.INFO)

        with mock.patch.dict(os.environ, {"Environment": "prod"}):
            log_level = set_log_level()
        self.assertEqual(log_level, logging.ERROR)

    @mock.patch("aws_lambda.http")
    def test_lambda_handler(self, mock_http):
        """
        Test case for lambda_handler
        """
        mock_http.request.return_value.status_code = 200
        mock_http.request.return_value.data = json.dumps(
            self.mock_json_data, ensure_ascii=False
        ).encode("utf8")
        s3_bucket = os.environ["S3_Bucket"]
        s3_object = os.environ["S3_Object"]
        event = {}
        result = lambda_handler(event, [])

        # verify the data was uploaded as expected
        s3_resource = boto3.resource("s3")
        s3_object = s3_resource.Object(s3_bucket, s3_object)
        actual = s3_object.get()["Body"].read()
        self.assertEqual(json.loads(actual), self.mock_sorted_json_data)
        self.assertEqual(result["result"], "success")

        with mock.patch.dict(os.environ, {"API_URL": "http://localhost:8080"}):
            mock_http.request.return_value.data = "error"
            result = lambda_handler(event, [])
        self.assertEqual(result["result"], "error")
