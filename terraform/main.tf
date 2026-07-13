# Automatically query the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 1. Fetch the default VPC explicitly
data "aws_vpc" "default" {
  default = true
}

# 2. Fetch subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create Security Group for Server 2 (Webserver)
resource "aws_security_group" "webserver_sg" {
  name        = "royal-hotel-webserver-sg"
  description = "Allow SSH and Java Web UI Traffic"
  
  # EXPLICITLY BIND VPC ID HERE:
  vpc_id      = data.aws_vpc.default.id

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
  
  # Attach explicitly fetched VPC Security Group ID and Subnet ID
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  tags = {
    Name        = "royal-hotel-dev-instance"
    Environment = "development"
    Project     = "royal-hotel-devops-pipeline"
  }
}
