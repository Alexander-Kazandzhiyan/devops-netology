# Настраиваем AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Ищем свежайший образ Ubuntu server
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Создаём блок адресации
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.17.0.0/16"

  tags = {
    Name = "ExampleVPC"
  }
}

# Создаём подсеть
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.17.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ExampleSubnet"
  }
}

# Создаём сетевой интерфейс с ip-адресом
resource "aws_network_interface" "my_interface" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.17.10.222"]

  tags = {
    Name = "Example_network_interface"
  }
}


# Описываем создаваемую ВМ
resource "aws_instance" "first-vm-from-terraform" {

# Для создания ВМ указываем найденный нами образ, точнее его id
  ami           = data.aws_ami.ubuntu.id

  instance_type = "t1.micro"

# При описании ВМ указываем свой, созданный сетевой интерфейс
  network_interface {
    network_interface_id = aws_network_interface.my_interface.id
    device_index         = 0
  }


  tags = {
    Name = "ExampleVM"
  }
}