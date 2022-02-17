resource "aws_ecs_cluster" "cl_ecs_cluster" {
    name = "carlos-cluster"
    setting {
      name = "containerInsights"
      value = "enabled"
    }
  
}

resource "aws_ecs_task_definition" "service" {
    family = "carlos-service"
    network_mode = "bridge"
    requires_compatibilities = ["EC2"]
    task_role_arn = aws_iam_role.ecsTaskExecution_role.arn
    execution_role_arn = aws_iam_role.ecsTaskExecution_role.arn
    container_definitions = jsonencode([
        {
            name = "carlos-service"
            image = "450183644535.dkr.ecr.us-east-2.amazonaws.com/carlos:latest"
            memory = 200
            cpu = 200
            essential = true 
            portMappings = [ 
              {
                  containerPort = 80 #Change to 3000 if break?
                  hostPort = 80 #80 or 3000?
              }
            ]
        },
    ])
}

resource "aws_ecs_service" "worker" {
    name = "carlos-service"
    cluster = aws_ecs_cluster.cl_ecs_cluster.id 
    task_definition = aws_ecs_task_definition.service.arn 
    desired_count = 2
    iam_role = "arn:aws:iam::450183644535:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS" 

    load_balancer {
        target_group_arn = var.autoscaleTGG 
        container_name = "carlos-service"
        container_port = 80 #Change to 3000 if break?
  
      
    }

  
}
