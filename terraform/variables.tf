variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for deploying Server 2 (dev-instance)"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance size for the development server"
}

variable "key_name" {
  type        = string
  default     = "control-hub-key" # <--- Changed default to reuse your Control Node key pair
  description = "SSH key pair name associated with the instance"
}
