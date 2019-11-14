provider "aws" {
  region = "ca-central-1"
}

module "vpc" {
  source = "git::https://spring.paloaltonetworks.com/tdugan/terraform-aws-egress-tgw-vpc?ref=v0.3.3"
  az_list = ["ca-central-1a"]
  vpc_network = "10.11.0.0/16"
  vpc_name = "asg unit test"
}  
module "launch_template" {
  source = "../../"
  vpc_zone_ids = module.vpc.mgmt_subnets[*].id
  extra_tags = [{key = "test", value = "test", propagate_at_launch = true}]
  asg_name = "test"
}
