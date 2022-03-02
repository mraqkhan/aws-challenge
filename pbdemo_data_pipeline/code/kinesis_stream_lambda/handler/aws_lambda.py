"""
lambda implementation for aws-challange provided
here: https://github.com/kernspin/aws-challenge
"""

import os
import logging
import json
import base64
import boto3


def set_log_level(default_env="dev"):
    """
    Method to set log level based on deployed enviroment
    """
    if os.environ.get("Environment", default_env) == "dev":
        log_level = logging.DEBUG
    elif os.environ.get("Environment", default_env) == "staging":
        log_level = logging.INFO
    else:
        log_level = logging.DEBUG

    return log_level


logger = logging.getLogger()
logger.setLevel(set_log_level())

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ.get("TABLE_NAME", "pbdemo_table"))


def lambda_handler(event, context):
    """
    This handler is invoked by aggregated stream event inserts all the
    elements in AWS DynamoDB through batchwrite
    """
    try:
        logger.debug("Event: %s", event)
        logger.debug("Context: %s", context)

        with table.batch_writer() as batch:
            for record in event["Records"]:
                decoded_item = base64.b64decode(record["kinesis"]["data"])
                batch.put_item(Item=json.loads(decoded_item))
                logger.debug("Inserted Data: %s", decoded_item)

        response = {"result": "success"}
        logger.debug("Lambda executed. Response: %s", response)

        return response
    except Exception as error:
        return {"result": "error", "error_message": str(error)}
