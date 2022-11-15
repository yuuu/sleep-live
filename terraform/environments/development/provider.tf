locals {
  profile        = "default"
  region         = "ap-northeast-1"
  provisioned_by = "terraform"
  env            = "dev"
}

provider "aws" {
  profile = local.profile
  region  = local.region
  default_tags {
    tags = {
      ProvisionedBy = local.provisioned_by
      Env           = local.env
    }
  }
}
