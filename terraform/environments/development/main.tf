terraform {
  required_version = "1.3.3"
}

module "s3" {
  source = "../../modules/s3"
  common = var.common
}

module "waf" {
  source   = "../../modules/waf"
  common   = var.common
  allow_ip = var.allow_ip
}

module "cloudfront" {
  source                 = "../../modules/cloudfront"
  common                 = var.common
  hosting_bucket         = module.s3.hosting_bucket
  origin_access_identity = module.s3.origin_access_identity
  acl                    = module.waf.acl
}

module "lambda" {
  source         = "../../modules/lambda"
  common         = var.common
  soracom        = var.soracom
  slack          = var.slack
  hosting_bucket = module.s3.hosting_bucket
  hosting_dst    = module.cloudfront.hosting_dst
}


module "eventbridge" {
  source               = "../../modules/eventbridge"
  common               = var.common
  is_sleeping_function = module.lambda.is_sleeping_function
}