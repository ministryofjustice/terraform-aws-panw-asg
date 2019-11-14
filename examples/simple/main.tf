provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "git::https://spring.paloaltonetworks.com/tdugan/terraform-aws-egress-tgw-vpc?ref=v0.3.3"
  az_list = ["us-east-2a"]
  vpc_network = "10.81.0.0/16"
  vpc_name = "asg unit test"
}  
module "launch_template" {
  source = "../../"
  vpc_zone_ids = module.vpc.mgmt_subnets[*].id
}
