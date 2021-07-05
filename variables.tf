#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Lambda Name  (e.g. `app` or `cluster`)."
}


variable "environment" {
  type        = string
  default     = ""
  description = "Lambda Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-lambda-site-monitor"
  description = "Terraform current module repo"
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create lambda function."
}

variable "ssl_check_enabled" {
  type        = bool
  default     = true
  description = "Whether to create lambda function."
}

variable "monitor_enabled" {
  type        = bool
  default     = true
  description = "Whether to create lambda function."
}

variable "variables" {
  type        = map(any)
  default     = {}
  description = "A map that defines environment variables for the Lambda function."
}

variable "ssl_variables" {
  type        = map(any)
  default     = {}
  description = "A map that defines environment variables for the Lambda function."
}

variable "slack_variables" {
  type        = map(any)
  default     = {}
  description = "A map that defines environment variables for the Lambda function."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "schedule_expression" {
  type        = string
  default     = "cron(*/5 * * * ? *)"
  description = "Schedule expression for site monitor lambda function."
}

variable "ssl_schedule_expression" {
  type        = string
  default     = "cron(*/5 * * * ? *)"
  description = "Schedule expression for site monitor lambda function."
}

variable "subnet_ids" {
  type        = list(any)
  default     = []
  description = "Subnet IDs."
}

variable "security_group_ids" {
  type        = list(any)
  default     = []
  description = "Security Group IDs."
}

variable "timeout" {
  type        = number
  default     = 30
  description = "timeout."
}
