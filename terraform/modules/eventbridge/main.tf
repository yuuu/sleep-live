resource "aws_cloudwatch_event_rule" "scheduled_event" {
  name                = "${var.common.app_name}-${var.common.env}-scheduled-event"
  schedule_expression = "cron(30 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "scheduled_event_target" {
  rule = aws_cloudwatch_event_rule.scheduled_event.name
  arn  = var.is_sleeping_function.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.is_sleeping_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_event.arn
}
