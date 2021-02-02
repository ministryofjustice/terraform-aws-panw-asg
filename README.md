Palo Alto Networks ASG module
===========

A terraform module for deploying GlobalProtect Gateways in an Auto Scaling Group.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| asg\_name | Name of ASG | `string` | `"PANSFW ASG"` | no |
| custom\_ami | Custom AMI for launch template | `string` | `null` | no |
| desired\_capacity | Desired capacity for ASG | `number` | `2` | no |
| fw\_product | Type of VM-Series to deploy.  Can be one of 'byol', 'bundle-1', 'bundle-2'. | `string` | `"byol"` | no |
| fw\_product\_map | n/a | `map(any)` | <pre>{<br>  "bundle-1": "6kxdw3bbmdeda3o6i1ggqt4km",<br>  "bundle-2": "806j2of0qy5osgjjixq9gqc6g",<br>  "byol": "6njl1pau431dv1qxipg63mvah"<br>}</pre> | no |
| fw\_version | Firewall version to deploy. | `string` | `"9.1.2"` | no |
| iam\_instance\_profile | IAM Instance Profile for launch template | `string` | `""` | no |
| instance\_type | Instance type for FW | `string` | `"m5.xlarge"` | no |
| key\_name | n/a | `any` | `null` | no |
| lambda\_sfn\_init\_arn | ARN of the sfn init function | `string` | n/a | yes |
| lambda\_sfn\_init\_name | Name of the sfn init function | `string` | n/a | yes |
| lifecycle\_metadata | Metadata values for the lifecycle hook | `string` | `""` | no |
| max\_size | Maximum instances for ASG | `number` | `4` | no |
| min\_size | Minimum instances for ASG | `number` | `2` | no |
| notification\_metadata | n/a | `map(any)` | `{}` | no |
| security\_group\_ids | List of security group Ids for instance Template | `list(string)` | `[]` | no |
| tags | A set of tags to be propagated to EC2 instances during scale events | `map(string)` | `{}` | no |
| user\_data | n/a | `any` | `null` | no |
| vpc\_zone\_ids | Subnets to launch in | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| active\_session\_scale\_down\_policy | n/a |
| active\_session\_scale\_up\_policy | n/a |
| asg | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
