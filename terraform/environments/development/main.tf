terraform {
  required_version = "1.3.3"
}

module "lambda" {
  source = "../../modules/lambda"
  common = var.common
}


module "eventbridge" {
  source               = "../../modules/eventbridge"
  common               = var.common
  is_sleeping_function = module.lambda.is_sleeping_function
}