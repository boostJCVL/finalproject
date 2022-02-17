data "aws_ami" "amazonlinux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}



resource "aws_security_group" "cl_alb_sg" {
    name = "cl_alb_sg"
    description = "Allow TLS inbound traffic"
    tags = {
        Name = "carlos_app_lb_sg"
    }
    vpc_id = var.vpc_id


    ingress  {
        description = "TLS from carlos VPC"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "cl_ec2_sg" {
    name = "cl_ec2_sg"
    description = "Allow TLS inbound traffic"
    tags = {
        Name = "carlos_ec2_sg"
    }
    vpc_id = var.vpc_id


    ingress  {
        description = "TLS from carlos VPC"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_launch_configuration" "ecs_config" {
    name_prefix = "carlos_ecs_"
    image_id = data.aws_ami.amazonlinux.id
    instance_type = "t3.medium"
    security_groups = [aws_security_group.cl_ec2_sg.id]
    user_data = templatefile("./modules/autoscaling/startup.sh",{clustername = var.clustername})
    iam_instance_profile = var.ecs_role1

    lifecycle {
      create_before_destroy = true
    }
  
}

resource "aws_autoscaling_group" "ecs_asg" {
    name = "carlos_ecs_asg"
    launch_configuration = aws_launch_configuration.ecs_config.name 
    min_size = var.min 
    max_size = var.max 
    desired_capacity = var.desired 
    vpc_zone_identifier = var.priv_subnets
    health_check_grace_period = 150
    health_check_type = "EC2" 
    
    lifecycle {
      create_before_destroy = true
      ignore_changes = [load_balancers, target_group_arns]
    }
}

resource "aws_autoscaling_attachment" "asg_attach_tg" {
    autoscaling_group_name = aws_autoscaling_group.ecs_asg.id 
    lb_target_group_arn = var.autoscaleTGG
  
}