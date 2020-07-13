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

#Module      : Cloudtrail Logs
#Description : This terraform module is designed to create site-monitoring.
module "site-monitor-rule" {
  source = "git::https://github.com/clouddrove/terraform-aws-cloudwatch-event-rule.git?ref=tags/0.12.1"

  name        = "site-monitor"
  application = var.application
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  enabled     = var.enabled

  description         = "Event Rule for site monitor."
  schedule_expression = var.schedule_expression

  target_id = format("%s-%s-%s", var.environment, var.application, var.name)
  arn       = format("arn:aws:lambda:%s:%s:function:%s-%s-%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.environment, var.application, var.name)
}

module "site-monitor" {
  source = "git::https://github.com/clouddrove/terraform-aws-lambda.git?ref=tags/0.12.5"

  name        = var.name
  application = var.application
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  enabled     = var.enabled

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
  source = "git::https://github.com/clouddrove/terraform-aws-lambda.git?ref=tags/0.12.5"

  name        = "monitor-lambda"
  application = var.application
  environment = var.environment
  label_order = var.label_order
  enabled     = var.enabled
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
  source = "git::https://github.com/clouddrove/terraform-aws-sns.git?ref=tags/0.12.2"

  name         = "monitor-sns"
  application  = var.application
  environment  = var.environment
  label_order  = var.label_order
  managedby    = var.managedby
  enable_topic = true
  enabled      = var.enabled

  protocol        = "lambda"
  endpoint        = module.lambda.arn
  delivery_policy = format("%s/_json/delivery_policy.json", path.module)
}
