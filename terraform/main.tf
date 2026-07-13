# Automatically query the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 1. Look up your specific VPC by Name tag
data "aws_vpc" "control_hub" {
  filter {
    name   = "tag:Name"
    values = ["control-hub-vpc"]
  }
}

# 2. Fetch public subnets in your control-hub-vpc
data "aws_subnets" "control_hub_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.control_hub.id]
  }
}

# Create Security Group inside control-hub-vpc
resource "aws_security_group" "webserver_sg" {
  name        = "royal-hotel-webserver-sg"
  description = "Allow SSH and Java Web UI Traffic"
  vpc_id      = data.aws_vpc.control_hub.id # <--- Explicitly attaches to control-hub-vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows Ansible connection
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows application web access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision Server 2 (dev-instance)
resource "aws_instance" "dev_instance" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  subnet_id                   = data.aws_subnets.control_hub_subnets.ids[0] # <--- Places instance in control-hub subnet
  associate_public_ip_address = true

  tags = {
    Name        = "royal-hotel-dev-instance"
    Environment = "development"
    Project     = "royal-hotel-devops-pipeline"
  }
}
