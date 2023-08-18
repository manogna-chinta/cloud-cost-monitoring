terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "komiser_role_ec2" # change the AWS profile here
}