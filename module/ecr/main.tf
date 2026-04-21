resource "aws_ecr_repository" "snake_repo" {
  name                 = "mio-snake-game"
  image_tag_mutability = "MUTABLE"
  force_delete         = true 

  image_scanning_configuration {
    scan_on_push = true 
  }
}

# Questa policy cancella automaticamente le immagini vecchie (tiene solo l'ultima)
resource "aws_ecr_lifecycle_policy" "cleanup" {
  repository = aws_ecr_repository.snake_repo.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only last image"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 1
      }
      action = {
        type = "expire"
      }
    }]
  })
}

output "repository_url" {
  value = aws_ecr_repository.snake_repo.repository_url
}
