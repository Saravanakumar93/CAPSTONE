terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.33.0"
    }
  }

  backend "s3" {
    bucket = "sara-project"
    key = "capstone/"
    region = "us-east-1"
  }

}
provider "aws" {
  region = "us-east-1"
}
