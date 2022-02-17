output "ecs_role1" {
    value = aws_iam_instance_profile.ecs_role1.name
}

output "clustername" {
    value = aws_ecs_cluster.cl_ecs_cluster.id
}