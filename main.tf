## pass in mgmt subnets here 
## pass in trust 
## pass in untrust 
data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["PA-VM-AWS-${var.fw_version_map[var.fw_version]}*"]
  }

  filter {
    name   = "product-code"
    values = ["${var.fw_product_map[var.fw_product]}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["aws-marketplace"]
}

resource "aws_launch_template" "this" {
  image_id = data.aws_ami.this.id  
  instance_type = var.instance_type
  user_data = var.user_data
  key_name = var.key_name
}

resource "aws_autoscaling_policy" "scale_out" {
  name = "panfw_scale_out"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = aws_autoscaling_group.this.name
}
resource "aws_autoscaling_policy" "scale_in" {
  name = "panfw_scale_in"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = aws_autoscaling_group.this.name
}
resource "aws_autoscaling_group" "this" {
  name               = var.asg_name
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier        = var.vpc_zone_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  } 

 initial_lifecycle_hook { 
  name                   = "launch-asg-panfw"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = <<EOF
{
  "foo": "bar"
}
EOF

  notification_target_arn = aws_sns_topic.launch.arn
  role_arn                = aws_iam_role.sns_role.arn
  }

 initial_lifecycle_hook { 
  name                   = "terminate-asg-panfw"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_metadata = <<EOF
{
  "foo": "bar"
}
EOF
  notification_target_arn = aws_sns_topic.terminate.arn
  role_arn                = aws_iam_role.sns_role.arn
  }
}

resource "aws_sns_topic" "launch" {
  name = "launch-panfw-topic"
}

resource "aws_sns_topic" "terminate" {
  name = "terminate-panfw-topic"
}

resource "aws_iam_role" "sns_role" {
  name = "Helpme" 
  path = "/"

  assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement": [{
    "Effect": "Allow",
    "Principal": {
        "Service": ["autoscaling.amazonaws.com"]
    },
    "Action": ["sts:AssumeRole"]
    }]
}
EOF
}

resource "aws_iam_role_policy" "ASGNotifierRolePolicy" {
  name = "helpme"
  role = aws_iam_role.sns_role.id

  policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement": [{
    "Effect": "Allow",
    "Action": "sns:Publish",
    "Resource": "${aws_sns_topic.launch.arn}"
    },
    {
    "Effect": "Allow",
    "Action": "sns:Publish",
    "Resource": "${aws_sns_topic.terminate.arn}"
    }]
}
EOF
}
