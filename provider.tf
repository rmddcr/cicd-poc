terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}


provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}
