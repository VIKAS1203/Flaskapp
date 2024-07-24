provider "aws" {
  region = "ap-south-1"  
}

# Define the EC2 instance
resource "aws_instance" "Terra_instance" {
  ami           = "Amazon Linux 2023 AMI 2023.5.20240722.0 x86_64 HVM kernel-6.1"
  instance_type = "t2.large"

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Use the default VPC and subnet
  subnet_id = data.aws_subnet_ids.default_subnet_ids.ids[0]
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Assign a public IP address
  associate_public_ip_address = true

  tags = {
    Name = "MyInstance"
  }
}

# Define the security group
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Data source to get the default VPC
data "aws_vpc" "default_vpc" {
  default = true
}

# Data source to get the default subnet IDs
data "aws_subnet_ids" "default_subnet_ids" {
  vpc_id = data.aws_vpc.default_vpc.id
}

output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}

