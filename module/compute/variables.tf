variable "vpc_id" {
  type = string
}



variable "container_image_url" {
  type = string
}

variable "subnet_pubblica_id" {
    type = string
}

variable "alb_sg_id" {
  type = string
}

variable "target_group_arn" {
  type        = string
  description = "ARN del target group che arriva dall'ALB"
}

variable "subnet_privata_id" {
    type = string
}

variable "subnet_privata2_id" {
    type = string
}