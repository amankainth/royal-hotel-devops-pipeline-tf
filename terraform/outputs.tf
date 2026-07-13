output "dev_instance_public_ip" {
  value       = aws_instance.dev_instance.public_ip
  description = "Public IP address of Server 2 (dev-instance)"
}

output "dev_instance_id" {
  value       = aws_instance.dev_instance.id
  description = "EC2 Instance ID of Server 2"
}