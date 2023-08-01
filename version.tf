terraform {
  required_version = ">=v1.4.2"
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
  # region = "ap-east-1"
  region = var.region
  alias  = "hk"
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
  alias  = "hz"
}
