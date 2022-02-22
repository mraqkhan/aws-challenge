# aws-challenge

Coding challenge: Create an AWS infrastructure consisting of a lambda function and S3 bucket.

# Scope
Create the cloud infrastructre:
- Set up the infrastructure as code in terraform
- A lambda function and S3 is needed
- Use appropriate security policies

Create a lambda function in Python:
- The lambda can be started by an unspecified event
- Query an API URL: http://pb-coding-challenge.s3-website.eu-central-1.amazonaws.com/metadata-sparse.json
- Parse the returned location metadata
- Sort the data by distance from the root geo location lat:50.9, lon:6.9
- Store the sorted data in a S3 bucket

# Some starting point for discussion
- Consider how you would make the lambda configurable, e.g. to query a different URL
- What and how would you test your code?
- How would you set up terraform if you would need to deploy to multiple environments?

# Delivery
Fork this repository and make your solution publicly available. 
