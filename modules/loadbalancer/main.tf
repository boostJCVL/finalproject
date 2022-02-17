resource "aws_lb_target_group" "autoscaleTG" {
    name = "autoscaleTG"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
}

resource "aws_lb" "ecslb" {
    name = "ecslb"
    internal = false
    load_balancer_type = "application"
    subnets = var.pub_subnets
    security_groups = [var.security_group]
    enable_deletion_protection = false
}

resource "aws_lb_listener" "front" {
    load_balancer_arn = aws_lb.ecslb.arn 
    port = "80" #Port that the LB checks during health checks
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.autoscaleTG.arn
    }
}

