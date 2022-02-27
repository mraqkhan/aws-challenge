"""
lambda implementation for aws-challange provided
here: https://github.com/kernspin/aws-challenge
"""

from math import radians, cos, sin, asin, sqrt
import os
import logging
import json
import urllib3
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
        log_level = logging.ERROR

    return log_level


logger = logging.getLogger()
logger.setLevel(set_log_level())

http = urllib3.PoolManager()
base_loc = (50.9, 6.9)


def lambda_handler(event, context):
    """
    This handler does three tasks
    1. Gets a response json from API_URL
    2. Sorts the response json based on distance from base_loc
    3. Writes the sorted json object to s3 bucket
    """
    try:
        logger.debug("Event: %s", event)
        logger.debug("Context: %s", context)

        logger.info("Call API to get geo data.")
        geo_data = fetch_geo_json(os.environ["API_URL"])

        logger.info("Sorting returned geo data based on distance from base_loc.")
        sort_geo_data(geo_data)

        logger.info("Writing Obj to s3")
        s3_save_object(os.environ["S3_Bucket"], os.environ["S3_Object"], geo_data)

        response = {"result": "success"}
        logger.debug("Lambda executed. Response: %s", response)

        return response
    except Exception as error:
        return {"result": "error", "error_message": str(error)}


def fetch_geo_json(url):
    """
    Get a json object from a url and loads it ito python dict object
    """
    resp = http.request("GET", url)
    logger.debug(resp.data)
    return json.loads(resp.data.decode("utf-8"))


def sort_geo_data(geo_data_object):
    """
    Sort a list on geo-locations based on distance from base_loc
    """
    # sort the list in-place using haversine method and return the same object
    geo_data_object["places"].sort(
        key=lambda x: haversine_distance(base_loc, (x["lat"], x["lon"]))
    )


def s3_save_object(s3_bucket, s3_object, content):
    """
    Save the content in an s3_object in the s3_bucket
    """
    # instanciate an s3 object and save content to it
    boto3.resource("s3").Bucket(s3_bucket).Object(s3_object).put(
        Body=json.dumps(content, ensure_ascii=False).encode("utf8"),
        ContentType="application/json",
        ACL="public-read",
    )


def haversine_distance(point1, point2):
    """
    This method calculates distance between two
    gps co-ordinates based on haversine formula
    """

    earth_radius = 6372800  # This is in meters

    # converting all points from degrees to radians
    delta_lat = radians(point2[0] - point1[0])
    delta_lon = radians(point2[1] - point1[1])
    lat1 = radians(point1[0])
    lat2 = radians(point2[0])

    # haversine formula to calculate distance between two geo co-ordinates
    arc_haver = (
        sin(delta_lat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(delta_lon / 2) ** 2
    )
    arc_distance = 2 * asin(sqrt(arc_haver))

    return earth_radius * arc_distance  # distance in meters
