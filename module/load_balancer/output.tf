output "alb_sg_id" {
  value       = aws_security_group.lb_sg.id
  description = "L'ID del Security Group del Load Balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.main.arn
  description = "L'ARN del Target Group per il servizio ECS"
}

