output "dataplane_cpu_scale_up_policy" {
  value = aws_autoscaling_policy.dataplane_cpu-scale_up.arn
}

output "dataplane_cpu_scale_down_policy" {
  value = aws_autoscaling_policy.dataplane_cpu-scale_down.arn
}
output "active_session_scale_up_policy" {
  value = aws_autoscaling_policy.active_session-scale_up.arn
}
output "active_session_scale_down_policy" {
  value = aws_autoscaling_policy.active_session-scale_down.arn
}

output "asg" {
  value = aws_autoscaling_group.this
}
