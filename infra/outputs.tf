output "task_role_arn" {
  value = aws_iam_role.task.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.images.bucket
}

output "service_url" {
  value = one(aws_ecs_express_gateway_service.app.ingress_paths).endpoint
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.main.dashboard_name
}

output "alarm_arn" {
  value = aws_cloudwatch_metric_alarm.bedrock_latency_high.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}