terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
  backend "s3" {
    bucket         = "aws-challange-tf-state-backend"
    acl            = "private"
    encrypt        = true
    region         = "us-east-1"
    dynamodb_table = "aws-challange-terraform_state-table"
    key            = "aws_challange.tfstate"
    profile        = "pbdemo"
}
  required_version = ">= 1.1.6"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}