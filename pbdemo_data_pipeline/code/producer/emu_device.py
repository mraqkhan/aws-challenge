"""
Purpose

Shows how to use the AWS SDK for Python (Boto3) with the Amazon Kinesis API to
generate a data stream. This script generates data for several of the _Windows
and Aggregation_ examples in the Amazon Kinesis Data Analytics SQL Developer Guide.
"""
from datetime import datetime
import json
import random
import time
import argparse
import math
import boto3
import urllib3


STREAM_NAME = "pbdemo_kinesis_stream_default"
API_URL = "http://pb-coding-challenge.s3-website.eu-central-1.amazonaws.com/metadata-sparse.json"


http = urllib3.PoolManager()


def get_data(loc_list, name):
    """
    returns a stream object
    """
    distance = round(random.uniform(0.22, 3.55), 2)
    latitude, longitude = generate_geo_points(loc_list, distance)
    cash_points = random.randint(0, 100)
    balance = random.randint(0, 1000)

    return {
        "Distance": distance,
        "CashPoints": cash_points,
        "Latitude": latitude,
        "Longitude": longitude,
        "Balance": balance,
        "Name": name,
        "StatusTime": str(datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")),
    }

def generate_geo_points(loc_list, distance):
    """
    Pick a random geo location and return a new geo-loc at a distance
    """

    earth_radius = 6378100  # Radius of the Earth
    bearing = 1.57  # Bearing is 90 degrees converted to radians.

    point = random.choice(loc_list)

    lat1 = math.radians(point["lat"])
    lon1 = math.radians(point["lon"])

    lat2 = math.asin(
        math.sin(lat1) * math.cos(distance / earth_radius)
        + math.cos(lat1) * math.sin(distance / earth_radius) * math.cos(bearing)
    )

    lon2 = lon1 + math.atan2(
        math.sin(bearing) * math.sin(distance / earth_radius) * math.cos(lat1),
        math.cos(distance / earth_radius) - math.sin(lat1) * math.sin(lat2),
    )

    lat2 = math.degrees(lat2)
    lon2 = math.degrees(lon2)

    return (lat2, lon2)


def generate(stream_name, kinesis_client, loc_list, name):
    """
    Generate stream data
    """
    while True:
        data = get_data(loc_list, name)
        print(data)
        kinesis_client.put_record(
            StreamName=stream_name, Data=json.dumps(data), PartitionKey="partitionkey"
        )
        time.sleep(2)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("name", help="name help")
    args = parser.parse_args()
    name_arg = args.name
    resp = http.request("GET", API_URL)
    geo_data = json.loads(resp.data.decode("utf-8"))
    geo_list = geo_data["places"]
    generate(STREAM_NAME, boto3.client("kinesis"), geo_list, name_arg)
