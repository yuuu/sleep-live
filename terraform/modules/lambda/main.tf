data "archive_file" "is_sleeping" {
  type        = "zip"
  source_dir  = "../../modules/lambda/is_sleeping/.build"
  output_path = "../../modules/lambda/is_sleeping/package.zip"
}

resource "aws_iam_role" "is_sleeping" {
  name = "${var.common.app_name}-${var.common.env}-is-sleeping-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "is_sleeping_attach" {
  role       = aws_iam_role.is_sleeping.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "is_sleeping" {
  filename      = data.archive_file.is_sleeping.output_path
  function_name = "${var.common.app_name}-${var.common.env}-is-sleeping"

  role = aws_iam_role.is_sleeping.arn

  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.is_sleeping.output_base64sha256
  runtime          = "ruby2.7"
  timeout          = 60

  environment {
    variables = {
      SORACOM_AUTH_KEY_ID       = var.soracom.auth_key_id
      SORACOM_AUTH_KEY_SECRET   = var.soracom.auth_key_secret
      SORACOM_SORACAM_DEVICE_ID = var.soracom.soracam_device_id
      SLACK_API_TOKEN           = var.slack.api_token
      SLACK_CHANNEL             = var.slack.channel
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.is_sleeping.function_name}"
  retention_in_days = 7
}
