## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | Whether to create lambda function. | `bool` | `true` | no |
| environment | Lambda Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | `string` | `"anmol@clouddrove.com"` | no |
| monitor\_enabled | Whether to create lambda function. | `bool` | `true` | no |
| name | Lambda Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-lambda-site-monitor"` | no |
| schedule\_expression | Schedule expression for site monitor lambda function. | `string` | `"cron(*/5 * * * ? *)"` | no |
| security\_group\_ids | Security Group IDs. | `list(any)` | `[]` | no |
| slack\_variables | A map that defines environment variables for the Lambda function. | `map(any)` | `{}` | no |
| ssl\_check\_enabled | Whether to create lambda function. | `bool` | `true` | no |
| ssl\_schedule\_expression | Schedule expression for site monitor lambda function. | `string` | `"cron(*/5 * * * ? *)"` | no |
| ssl\_variables | A map that defines environment variables for the Lambda function. | `map(any)` | `{}` | no |
| subnet\_ids | Subnet IDs. | `list(any)` | `[]` | no |
| timeout | timeout. | `number` | `30` | no |
| variables | A map that defines environment variables for the Lambda function. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) identifying your cloudtrail logs Lambda Function. |
| sns\_arn | The SNS topic to which CloudWatch Alarms will be sent. |
| sns\_id | The SNS topic to which CloudWatch Alarms will be sent. |
| tags | A mapping of tags to assign to the resource. |

