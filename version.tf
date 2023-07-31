terraform {
  required_version = "1.4.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }

    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.208.1"
    }
  }
}

provider "aws" {
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  region = "ap-east-1"
}

provider "alicloud" {
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  region = "cn-hangzhou-a"
}

provider "alicloud" {
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  region = "cn-hangzhou-b"
}
