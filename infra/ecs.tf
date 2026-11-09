data "aws_ecr_repository" "app" {
  name = var.ecr_repository_name
}

resource "aws_ecs_express_gateway_service" "app" {
  service_name            = "wishifai-candidate${var.candidate_number}"
  execution_role_arn      = data.aws_iam_role.ecs_task_execution.arn
  infrastructure_role_arn = data.aws_iam_role.ecs_infrastructure.arn
  task_role_arn           = aws_iam_role.task.arn

  health_check_path     = "/api/health"
  wait_for_steady_state = true

  primary_container {
    image          = "${data.aws_ecr_repository.app.repository_url}:${var.image_tag}"
    container_port = 8080

    environment {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.images.bucket
    }

    environment {
      name  = "BEDROCK_MODEL_ID"
      value = var.bedrock_model_id
    }
  }

  depends_on = [
    aws_iam_role_policy.task_permissions
  ]
}