variable "alert_email" {
  description = "Email address receiving CloudWatch alarm notifications"
  type        = string
}

resource "aws_sns_topic" "alerts" {
  name = "${var.resource_prefix}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "bedrock_latency_high" {
  alarm_name          = "${var.resource_prefix}-bedrock-latency-high"
  alarm_description   = "Alerts when the average Bedrock response time exceeds 30 seconds."
  comparison_operator = "GreaterThanThreshold"

  namespace   = var.resource_prefix
  metric_name = "wishifai.bedrock.duration"

  statistic          = "Average"
  period             = 300
  evaluation_periods = 2
  threshold          = 30
  unit               = "Seconds"

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]
}