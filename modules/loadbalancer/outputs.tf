output "autoscaleTG" {
    value = aws_lb_target_group.autoscaleTG.id
}

output "autoscaleTGG" {
    value = aws_lb_target_group.autoscaleTG.arn
}