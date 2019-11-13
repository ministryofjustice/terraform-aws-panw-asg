output "scale_out_policy" {
  value = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy" {
  value = aws_autoscaling_policy.scale_in.arn
}

output "asg" {
  value = aws_autoscaling_group.this
}
