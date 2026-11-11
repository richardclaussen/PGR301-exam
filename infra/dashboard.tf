locals {
  ecs_service_name = "wishifai-candidate${var.candidate_number}"
}


resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.resource_prefix}-dashboard"

  dashboard_body = <<DASHBOARD
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${var.resource_prefix}",
            "wishifai.images.analyzed"
          ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "${var.aws_region}",
        "title": "Business: analyzed images"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${var.resource_prefix}",
            "wishifai.gifts.generated"
          ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "${var.aws_region}",
        "title": "Business: generated gifts"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/ECS",
            "CPUUtilization",
            "ClusterName",
            "${var.ecs_cluster_name}",
            "ServiceName",
            "${local.ecs_service_name}"
          ],
          [
            ".",
            "MemoryUtilization",
            ".",
            ".",
            ".",
            "."
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Infrastructure: ECS CPU and Memory"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/ECS",
            "RunningTaskCount",
            "ClusterName",
            "${var.ecs_cluster_name}",
            "ServiceName",
            "${local.ecs_service_name}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Infrastructure: running tasks"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 12,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${var.resource_prefix}",
            "wishifai.bedrock.duration"
          ],
          [
            "${var.resource_prefix}",
            "wishifai.rekognition.duration"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Application: response time"
      }
    },
    {
      "type": "alarm",
      "x": 0,
      "y": 18,
      "width": 24,
      "height": 6,
      "properties": {
        "title": "Alarm: Bedrock-response time",
        "alarms": [
          "${aws_cloudwatch_metric_alarm.bedrock_latency_high.arn}"
        ]
      }
    }
  ]
}
DASHBOARD
}
