output "sns_arn" {
  value       = module.site-monitor.*.sns_arn
  description = "The ARN of the SNS platform application."
}
output "tags" {
  value       = module.site-monitor.tags
  description = "A mapping of tags to assign to the resource."
}
