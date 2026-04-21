resource "aws_lb" "main" {
  name= "test-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb_sg.id]
  subnets = [var.subnet_pubb, var.subnet_pubb2]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "main" {
  name = "snake-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

    health_check {
      path = "/"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn # Collega all'ALB che hai appena scritto tu
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

#sg per lb
resource "aws_security_group" "lb_sg" {
  name = "snake-alb-sg"
  vpc_id=var.vpc_id

  ingress {                               #definiamo regole in ingresso
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {                               #definiamo regole in uscita
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
}