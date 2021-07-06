## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "null_resource" "site-monitor" {
  provisioner "local-exec" {
    command = format("cd %s/monitor && bash build.sh", path.module)
  }
}

resource "null_resource" "lambda" {
  provisioner "local-exec" {
    command = format("cd %s/slack && bash build.sh", path.module)
  }
}

resource "null_resource" "ssl-check" {
  provisioner "local-exec" {
    command = format("cd %s/ssl-check && bash build.sh", path.module)
  }
}

#Module      : Cloudtrail Logs
#Description : This terraform module is designed to create site-monitoring.
module "site-monitor-rule" {
  source  = "clouddrove/cloudwatch-event-rule/aws"
  version = "0.15.0"


  name        = "site-monitor"
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  enabled     = var.enabled && var.monitor_enabled

  description         = "Event Rule for site monitor."
  schedule_expression = var.schedule_expression

  target_id = format("%s-%s", var.environment, var.name)
  arn       = format("arn:aws:lambda:%s:%s:function:%s-%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.environment, var.name)
}

module "site-monitor" {
  source  = "clouddrove/lambda/aws"
  version = "0.15.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  enabled     = var.enabled && var.monitor_enabled

  filename = format("%s/monitor/src", path.module)
  handler  = "index.handler"
  runtime  = "python3.8"
  iam_actions = [
    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "logs:PutLogEvents",
    "cloudwatch:PutMetricAlarm",
    "cloudwatch:PutMetricData",
    "ec2:CreateNetworkInterface",
    "ec2:DescribeNetworkInterfaces",
    "ec2:DeleteNetworkInterface"
  ]
  timeout = var.timeout

  names = [
    "python_layer"
  ]
  layer_filenames = [format("%s/monitor/packages/Python3-monitor.zip", path.module)]
  compatible_runtimes = [
    ["python3.8"]
  ]

  statement_ids = [
    "AllowExecutionFromCloudWatch"
  ]
  actions = [
    "lambda:InvokeFunction"
  ]
  principals = [
    "events.amazonaws.com"
  ]
  source_arns        = module.site-monitor-rule.arn
  variables          = var.variables
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

module "lambda" {
  source  = "clouddrove/lambda/aws"
  version = "0.15.0"

  name        = "monitor-lambda"
  environment = var.environment
  label_order = var.label_order
  enabled     = var.enabled && var.monitor_enabled
  managedby   = var.managedby

  filename = format("%s/slack/src", path.module)
  handler  = "index.handler"
  runtime  = "nodejs12.x"
  iam_actions = [
    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "logs:PutLogEvents",
    "sns:ListTopics",
  ]
  timeout = 30

  names = [
    "node_layer"
  ]
  layer_filenames = [format("%s/slack/layer/nodejs.zip", path.module)]
  compatible_runtimes = [
    ["nodejs12.x"]
  ]

  statement_ids = [
    "AllowExecutionFromSNS"
  ]
  actions = [
    "lambda:InvokeFunction"
  ]
  principals = [
    "sns.amazonaws.com"
  ]
  source_arns = [module.sns.topic-arn]
  variables   = var.slack_variables
}

#Module      : SNS
#Description : Provides an SNS topic resource
module "sns" {
  source  = "clouddrove/sns/aws"
  version = "0.15.0"

  name         = "monitor-sns"
  environment  = var.environment
  label_order  = var.label_order
  managedby    = var.managedby
  enable_topic = true
  enabled      = var.enabled && var.monitor_enabled

  protocol        = "lambda"
  endpoint        = module.lambda.arn
  delivery_policy = format("%s/_json/delivery_policy.json", path.module)
}

#Module      : Cloudtrail Logs
#Description : This terraform module is designed to create site ssl check.
module "ssl-check-rule" {
  source  = "clouddrove/cloudwatch-event-rule/aws"
  version = "0.15.0"

  name        = "ssl-check"
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  enabled     = var.enabled && var.ssl_check_enabled

  description         = "Event Rule for site ssl check."
  schedule_expression = var.ssl_schedule_expression

  target_id = format("%s-%s", var.environment, var.name)
  arn       = format("arn:aws:lambda:%s:%s:function:%s-%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.environment, var.name)
}

module "ssl-check" {
  source  = "clouddrove/lambda/aws"
  version = "0.15.0"

  name        = "ssl-check"
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  enabled     = var.enabled && var.ssl_check_enabled

  filename = format("%s/ssl-check/src", path.module)
  handler  = "index.handler"
  runtime  = "python3.8"
  iam_actions = [
    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "logs:PutLogEvents",
    "cloudwatch:PutMetricAlarm",
    "cloudwatch:PutMetricData",
    "ec2:CreateNetworkInterface",
    "ec2:DescribeNetworkInterfaces",
    "ec2:DeleteNetworkInterface"
  ]
  timeout = var.timeout

  names = [
    "python_layer"
  ]
  layer_filenames = [format("%s/ssl-check/packages/Python3-ssl-check.zip", path.module)]
  compatible_runtimes = [
    ["python3.8"]
  ]

  statement_ids = [
    "AllowExecutionFromCloudWatch"
  ]
  actions = [
    "lambda:InvokeFunction"
  ]
  principals = [
    "events.amazonaws.com"
  ]
  source_arns        = module.ssl-check-rule.arn
  variables          = var.ssl_variables
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}
