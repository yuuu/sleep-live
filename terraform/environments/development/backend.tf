terraform {
  // このbucketは手動で作っておく
  backend "s3" {
    bucket  = "sleep-live-development"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "default"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34"
    }
  }
}
