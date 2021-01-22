variable "fw_version" {
  description = "Firewall version to deploy."
  type        = string
  default     = "9.1.2"
}

variable "fw_product" {
  description = "Type of VM-Series to deploy.  Can be one of 'byol', 'bundle-1', 'bundle-2'."
  default     = "byol"
}

variable "fw_product_map" {
  type = map(any)

  default = {
    byol     = "6njl1pau431dv1qxipg63mvah"
    bundle-1 = "6kxdw3bbmdeda3o6i1ggqt4km"
    bundle-2 = "806j2of0qy5osgjjixq9gqc6g"
  }
}

variable "instance_type" {
  description = "Instance type for FW"
  default     = "m5.xlarge"
}

variable "user_data" {
  default = null
}

variable "key_name" {
  default = null
}

variable "desired_capacity" {
  description = "Desired capacity for ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum instances for ASG"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum instances for ASG"
  type        = number
  default     = 2
}

variable "vpc_zone_ids" {
  description = "Subnets to launch in"
  type        = list(string)
  default     = []
}

variable "asg_name" {
  description = "Name of ASG"
  type        = string
  default     = "PANSFW ASG"
}

variable "custom_ami" {
  description = "Custom AMI for launch template"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group Ids for instance Template"
  type        = list(string)
  default     = []
}


variable "notification_metadata" {
  type    = map(any)
  default = {}
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile for launch template"
  type        = string
  default     = ""
}

variable "lifecycle_metadata" {
  description = "Metadata values for the lifecycle hook"
  type        = string
  default     = ""
}

variable "lambda_sfn_init_arn" {
  description = "ARN of the sfn init function"
  type        = string
}

variable "lambda_sfn_init_name" {
  description = "Name of the sfn init function"
  type        = string
}

variable "tags" {
  description = "A set of tags to be propagated to EC2 instances during scale events"
  type        = map(string)
  default     = {}
}
