<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS Lambda Site Monitor
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module to create Lambda resource on AWS for monitor different websites.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.1.7-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>
<a href="https://github.com/clouddrove/terraform-aws-lambda-site-monitor/actions/workflows/tfsec.yml">
  <img src="https://github.com/clouddrove/terraform-aws-lambda-site-monitor/actions/workflows/tfsec.yml/badge.svg" alt="tfsec">
</a>
<a href="https://github.com/clouddrove/terraform-aws-lambda-site-monitor/actions/workflows/terraform.yml">
  <img src="https://github.com/clouddrove/terraform-aws-lambda-site-monitor/actions/workflows/terraform.yml/badge.svg" alt="static-checks">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-lambda-site-monitor'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+Lambda+Site+Monitor&url=https://github.com/clouddrove/terraform-aws-lambda-site-monitor'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+Lambda+Site+Monitor&url=https://github.com/clouddrove/terraform-aws-lambda-site-monitor'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-lambda-site-monitor/releases).


### Simple example
Here is an example of how you can use this module in your inventory structure:
```hcl
module "cloudtrail-slack-notification" {
  source  = "clouddrove/lambdasite-monitor/aws"
  version = "1.0.1"

  name        = "site-monitor"
  environment = "test"
  label_order = ["environment", "name"]
  enabled     = true
  schedule_expression = "cron(*/5 * * * ? *)"
  variables = {
    Website_URL = jsonencode(["https://google.com"]),
    metricname  = "Site Availability"
    timeout = 5
  }
  slack_variables = {
    SLACK_WEBHOOK = "https://hooks.slack.com/services/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yrrh08dJo5r1Y"
  }
}
```






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




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-lambda-site-monitor/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-lambda-site-monitor)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
