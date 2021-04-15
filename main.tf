data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["PA-VM-AWS-${var.fw_version}*"]
  }

  filter {
    name   = "product-code"
    values = [var.fw_product_map[var.fw_product]]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["aws-marketplace"]
}

resource "aws_launch_template" "this" {
  image_id               = var.custom_ami != null ? var.custom_ami : data.aws_ami.this.id
  instance_type          = var.instance_type
  user_data              = var.user_data
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile {
    name = var.iam_instance_profile
  }
}

# resource "aws_autoscaling_policy" "dataplane_cpu-scale_up" {
#   name                   = "panfw_scale_out"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 600
#   autoscaling_group_name = aws_autoscaling_group.this.name
# }
# resource "aws_autoscaling_policy" "dataplane_cpu-scale_down" {
#   name                   = "panfw_scale_in"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 600
#   autoscaling_group_name = aws_autoscaling_group.this.name
# }
resource "aws_autoscaling_policy" "active_sessions-scale_up" {
  name                   = "panfw_scale_out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 1800
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "active_sessions-scale_down" {
  name                   = "panfw_scale_in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 3600
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_group" "this" {
  name                = var.asg_name
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.vpc_zone_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tags = [for key, value in var.tags : merge({ key = key }, { value = value }, { propagate_at_launch = "true" })]


}

resource "aws_autoscaling_lifecycle_hook" "launch" {
  name                   = "launch-asg-panfw"
  autoscaling_group_name = aws_autoscaling_group.this.name
  default_result         = "ABANDON"
  heartbeat_timeout      = 1800
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
  notification_metadata  = var.lifecycle_metadata

  notification_target_arn = aws_sns_topic.this.arn
  role_arn                = aws_iam_role.sns_role.arn
}

resource "aws_autoscaling_lifecycle_hook" "terminate" {
  name                   = "terminate-asg-panfw"
  autoscaling_group_name = aws_autoscaling_group.this.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_metadata = var.lifecycle_metadata

  notification_target_arn = aws_sns_topic.this.arn
  role_arn                = aws_iam_role.sns_role.arn
}

resource "aws_sns_topic" "this" {
  name = "panfw-autoscale-topic"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.id
  protocol  = "lambda"
  endpoint  = var.lambda_sfn_init_arn
}

# Assigns lambda a resource based policy. Required to get triggered via SNS
resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_sfn_init_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this.arn
}

# resource "aws_autoscaling_notification" "this" {
#   group_names = [
#     aws_autoscaling_group.this.name,
#   ]

#   notifications = [
#     "autoscaling:EC2_INSTANCE_LAUNCH",
#     "autoscaling:EC2_INSTANCE_TERMINATE",
#     "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
#     "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
#   ]

#   topic_arn = aws_sns_topic.this.arn
# }

resource "aws_iam_role" "sns_role" {
  name = "${var.asg_name}_SNS_Role"
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
  name = "${var.asg_name}_ASGNotifier_Policy"
  role = aws_iam_role.sns_role.id

  policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sns:Publish",
        "Resource": "${aws_sns_topic.this.arn}"
      }
    ]
}
EOF
}
