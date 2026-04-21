output "cluster_name" {
  value = aws_ecs_cluster.snake_cluster.name
}

output "service_name" {
  value = aws_ecs_service.snake_service.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.snake_task.arn
}
