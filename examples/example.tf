provider "aws" {
  region = "eu-west-1"
}

module "site-monitor" {
  source = "./../"

  name                = "site-monitor"
  environment         = "test"
  label_order         = ["environment", "name"]
  enabled             = true
  monitor_enabled     = true
  ssl_check_enabled   = true
  schedule_expression = "cron(*/5 * * * ? *)"
  variables = {
    Website_URL = jsonencode(["https://google.com"]),
    metricname  = "Site Availability"
    timeout     = 5
  }
  slack_variables = {
    slack_webhook = "https://hooks.slack.com/services/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yrrh08dJo5r1Y"
  }
  ssl_variables = {
    domains       = jsonencode(["clouddrove.com"]),
    slack_webhook = "https://hooks.slack.com/services/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yrrh08dJo5r1Y"
    slack_channel = "testing"
  }
}

module "alarm" {
  source  = "clouddrove/cloudwatch-alarms/aws"
  version = "1.3.2"

  name        = "alarm"
  environment = "test"
  label_order = ["environment", "name"]

  alarm_name          = "website-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Site Availability"
  namespace           = "Website Status"
  period              = 300
  statistic           = "Average"
  threshold           = 200
  alarm_description   = "google.com status"
  alarm_actions       = [module.site-monitor.sns_arn]

  actions_enabled           = true
  insufficient_data_actions = [module.site-monitor.sns_arn]
  ok_actions                = [module.site-monitor.sns_arn]
  dimensions = {
    Website = "https://google.com",
    Status  = "WebsiteStatusCode"
  }
}
