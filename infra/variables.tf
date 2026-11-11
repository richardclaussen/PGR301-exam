variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "eu-west-1"
}

variable "candidate_number" {
  description = "The candidate number"
  type        = string
  default     = "50"
}

variable "image_tag" {
  description = "The image tag to use for the application"
  type        = string
  default     = "latest"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "candidate50-wishifai"
}

variable "bedrock_model_id" {
  description = "The Bedrock model ID to use for the application"
  type        = string
  default     = "eu.anthropic.claude-sonnet-4-5-20250929-v1:0"
}

variable "resource_prefix" {
  description = "Prefix for unique resource names"
  type        = string
  default     = "wishifai-candidate50"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster used by the Express service"
  type        = string
  default     = "default"
}