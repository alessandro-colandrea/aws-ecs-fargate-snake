#output utili nel main root
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_pubblica_id" {
  value = aws_subnet.pubblica.id
}

output "subnet_privata_id" {
  value = aws_subnet.privata.id
}

output "subnet_pubblica2_id" {
  value = aws_subnet.pubblica2.id
}

output "subnet_privata2_id" {
  value = aws_subnet.privata2.id
}