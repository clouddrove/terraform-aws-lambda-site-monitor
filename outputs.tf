# Module      : Lambda
# Description : Terraform module to create Lambda resource on AWS for managing queue.
output "arn" {
  value       = module.site-monitor.arn
  description = "The Amazon Resource Name (ARN) identifying your cloudtrail logs Lambda Function."
}

output "sns_id" {
  description = "The SNS topic to which CloudWatch Alarms will be sent."
  value       = var.enabled ? module.sns.topic-id : null
}

output "sns_arn" {
  description = "The SNS topic to which CloudWatch Alarms will be sent."
  value       = var.enabled ? module.sns.topic-arn : null
}
output "tags" {
  value       = module.site-monitor.tags
  description = "A mapping of tags to assign to the resource."
}
