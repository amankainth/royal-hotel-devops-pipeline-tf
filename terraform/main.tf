# Automatically query the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Provision Server 2 (dev-instance)
resource "aws_instance" "dev_instance" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  tags = {
    Name        = "royal-hotel-dev-instance"
    Environment = "development"
    Project     = "royal-hotel-devops-pipeline"
  }
}