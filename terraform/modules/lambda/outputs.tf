output "is_sleeping_function" {
  value = {
    function_name = aws_lambda_function.is_sleeping.function_name
    arn           = aws_lambda_function.is_sleeping.arn
  }
}
