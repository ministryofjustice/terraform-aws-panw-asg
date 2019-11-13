provider "aws" {
  region = "us-east-2"
}

module "launch_template" {
  source = "../../"
  vpc_zone_ids = ["subnet-014eefff20469e9c9", "subnet-078490c5b7157765d", "subnet-078490c5b7157765d"]
  custom_ami = "ami-042faf039bdaecad0"
}
