# Creiamo l'ecs cluster (dove saranno i container)
resource "aws_ecs_cluster" "snake_cluster" {
  name = "snake-game-cluster"
}

#Creazione solo del ruolo (vuoto)
resource "aws_iam_role" "ecs_execution_role" {
  name = "snake-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" } #solo questo servizio
    }]
  })
}
#Definiamo la policy (cosa puo fare)
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name  #colleghiamo al ruolo sopra
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" #policy predefinita per ecs
}

#Task Definition (Qui definisci le risorse del container)
resource "aws_ecs_task_definition" "snake_task" {
  family                   = "snake-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # 0.25 vCPU
  memory                   = "512" # 0.5 GB
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name      = "snake-container"
    image     = var.container_image_url # Variabile che conterrà l'URL dell'immagine
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])
}

# 4. ECS Service (Lancia il task nella tua subnet privata)
resource "aws_ecs_service" "snake_service" {
  name            = "snake-service"
  cluster         = aws_ecs_cluster.snake_cluster.id
  task_definition = aws_ecs_task_definition.snake_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  
load_balancer {
    target_group_arn = var.target_group_arn       # target group del lb
    container_name   = "snake-container"           # Deve essere identico al name nella task_definition
    container_port   = 80
  }

  network_configuration {
    subnets          = [var.subnet_privata_id, var.subnet_privata_id] 
    security_groups  = [aws_security_group.ecs_sg.id]        
    assign_public_ip = false               # Siamo in privata, usiamo il NAT
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "snake-ecs-sg"
  description = "Permette traffico HTTP sulla porta 80"
  vpc_id      = var.vpc_id 

  # permettiamo il traffico sulla porta 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]
  }

  # per scaricare l'immagine Docker e i log
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "snake-sg"
  }
}
