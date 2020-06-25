provider "aws" {
  region = "eu-west-1"
}

module "site-monitor" {
  source = "./../"

  name                = "site-monitor"
  application         = "clouddrove"
  environment         = "test"
  label_order         = ["environment", "application", "name"]
  enabled             = true
  schedule_expression = "cron(*/5 * * * ? *)"
  variables = {
    Website_URL = jsonencode(["https://google.com"]),
    metricname  = "Site Availability"
  }
  slack_variables = {
    SLACK_WEBHOOK = "https://hooks.slack.com/services/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r1Y"
  }
}

module "alarm" {
  source = "git::https://github.com/clouddrove/terraform-aws-cloudwatch-alarms.git?ref=tags/0.12.3"

  name        = "alarm"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  alarm_name          = "website-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Site Availability"
  namespace           = "Website Status"
  period              = 300
  statistic           = "Average"
  threshold           = 200
  alarm_description   = "https://google.com status"
  alarm_actions       = ["arn:aws:sns:eu-west-1:xxxxxxxxxxxxxx:test-clouddrove-monitor-sns"]

  actions_enabled           = true
  insufficient_data_actions = []
  ok_actions                = ["arn:aws:sns:eu-west-1:xxxxxxxxxxxxxx:test-clouddrove-monitor-sns"]
  dimensions = {
    Website = "https://google.com",
    Status  = "WebsiteStatusCode"
  }
}