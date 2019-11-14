variable "fw_version" {
  description = "Firewall version to deploy."
  #default     = "90"
  default = "81"
  #default = "80"
}

variable "fw_product" {
  description = "Type of VM-Series to deploy.  Can be one of 'byol', 'bundle-1', 'bundle-2'."
  default     = "byol"
}

variable "fw_version_map" {
  type = "map"

  default = {
    90 = "9.0.3"
    81 = "8.1.9"
    80 = "8.0.17"
    }
}
variable "fw_product_map" {
  type = "map"

  default = {
    byol     = "6njl1pau431dv1qxipg63mvah"
    bundle-1 = "6kxdw3bbmdeda3o6i1ggqt4km"
    bundle-2 = "806j2of0qy5osgjjixq9gqc6g"
  }
}

variable "instance_type" {
    description = "Instance type for FW"
    default = "m4.xlarge"
}

variable "user_data" {
    default = null 
}

variable "key_name" {
  default = null 
}

variable "desired_capacity" {
  description = "Desired capacity for ASG"
  type = number
  default = 1
 } 

variable "max_size" {
  description = "Maximum instances for ASG"
  type = number
  default = 1
 } 

variable "min_size" {
  description = "Minimum instances for ASG"
  type = number
  default = 1
 } 

 variable "vpc_zone_ids" {
  description = "Subnets to launch in"
  type = list(string)
  default = []
}

variable "asg_name" {
  description = "Name of ASG"
  type = string
  default = "PANSFW ASG"
}

variable "custom_ami" {
  description = "Custom AMI for launch template"
  type = string
  default = null
}

variable "security_group_ids" {
  description = "List of security group Ids for instance Template"
  type = list(string)
  default = []
}

variable "extra_tags" {
  description = "Extra tags to assign to ASG"
  default = [{
    key = null
    value = null
    proprogate_at_launch = null
    }]
  type =  list(object({
    key = string
    value = string
    propagate_at_launch = bool
  }))
}  
