# Definiamo COSA vogliamo scalare (il Target)
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4                      # Massimo 4 container
  min_capacity       = 1                      # Minimo 1 container
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# scala in base all'uso medio della CPU
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "target-tracking-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 10.0 
  }
}
