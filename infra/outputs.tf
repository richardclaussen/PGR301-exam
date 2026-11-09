output "task_role_arn" {
  value = aws_iam_role.task.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.images.bucket
}

output "service_url" {
  value = one(aws_ecs_express_gateway_service.app.ingress_paths).endpoint
}