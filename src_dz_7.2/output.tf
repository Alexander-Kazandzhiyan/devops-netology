
# Получаем данные Региона AWS
data "aws_region" "current" {}

# Выводим регион
output "region" {
  value = data.aws_region.current.id
}

# Получаем данные под которыми Terraform работает с AWS
data "aws_caller_identity" "current" {}

# Выводим номер аккаунта
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Выводим пользователя
output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

# Выводим ID ВМ
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.first-vm-from-terraform.id
}


output "instance_subnet" {
#  description = "Subnet of the EC2 instance"
  value       = aws_instance.first-vm-from-terraform.subnet_id
}

output "instance_local_ip" {
  description = "Local IP address of the EC2 instance"
  value       = aws_instance.first-vm-from-terraform.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.first-vm-from-terraform.public_ip
}
