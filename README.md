Palo Alto Networks ASG module
===========

A terraform module for deploying GlobalProtect Gateways in an Auto Scaling Group.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_lifecycle_hook.launch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_lifecycle_hook) | resource |
| [aws_autoscaling_lifecycle_hook.terminate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_lifecycle_hook) | resource |
| [aws_autoscaling_policy.active_sessions-scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.active_sessions-scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_iam_role.sns_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ASGNotifierRolePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_permission.with_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Name of ASG | `string` | `"PANSFW ASG"` | no |
| <a name="input_custom_ami"></a> [custom\_ami](#input\_custom\_ami) | Custom AMI for launch template | `string` | `null` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired capacity for ASG | `number` | `2` | no |
| <a name="input_fw_product"></a> [fw\_product](#input\_fw\_product) | Type of VM-Series to deploy.  Can be one of 'byol', 'bundle-1', 'bundle-2'. | `string` | `"byol"` | no |
| <a name="input_fw_product_map"></a> [fw\_product\_map](#input\_fw\_product\_map) | n/a | `map(any)` | <pre>{<br>  "bundle-1": "6kxdw3bbmdeda3o6i1ggqt4km",<br>  "bundle-2": "806j2of0qy5osgjjixq9gqc6g",<br>  "byol": "6njl1pau431dv1qxipg63mvah"<br>}</pre> | no |
| <a name="input_fw_version"></a> [fw\_version](#input\_fw\_version) | Firewall version to deploy. | `string` | `"9.1.2"` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM Instance Profile for launch template | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for FW | `string` | `"m5.xlarge"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | n/a | `any` | `null` | no |
| <a name="input_lambda_sfn_init_arn"></a> [lambda\_sfn\_init\_arn](#input\_lambda\_sfn\_init\_arn) | ARN of the sfn init function | `string` | n/a | yes |
| <a name="input_lambda_sfn_init_name"></a> [lambda\_sfn\_init\_name](#input\_lambda\_sfn\_init\_name) | Name of the sfn init function | `string` | n/a | yes |
| <a name="input_lifecycle_metadata"></a> [lifecycle\_metadata](#input\_lifecycle\_metadata) | Metadata values for the lifecycle hook | `string` | `""` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum instances for ASG | `number` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum instances for ASG | `number` | `2` | no |
| <a name="input_notification_metadata"></a> [notification\_metadata](#input\_notification\_metadata) | n/a | `map(any)` | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group Ids for instance Template | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A set of tags to be propagated to EC2 instances during scale events | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | n/a | `any` | `null` | no |
| <a name="input_vpc_zone_ids"></a> [vpc\_zone\_ids](#input\_vpc\_zone\_ids) | Subnets to launch in | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_session_scale_down_policy"></a> [active\_session\_scale\_down\_policy](#output\_active\_session\_scale\_down\_policy) | n/a |
| <a name="output_active_session_scale_up_policy"></a> [active\_session\_scale\_up\_policy](#output\_active\_session\_scale\_up\_policy) | n/a |
| <a name="output_asg"></a> [asg](#output\_asg) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
