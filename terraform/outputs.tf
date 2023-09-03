###################
# Backend outputs #
###################

output "backend_public_ip"{
    value       = aws_instance.ec2_backend_instance.public_ip
    description = "The public ip address assigned by AWS"
}
output "backend_private_ip" {
    value       = aws_instance.ec2_backend_instance.private_ip
    description = "The internal ip address assigned by AWS"
}
output "backend_private_key" {
    value       = tls_private_key.this[0].private_key_pem
    sensitive   = true
    description = "The private key to access the EC2 instance"
}


####################
# Frontend outputs #
####################

output "frontend_public_ip"{
    value       = aws_instance.ec2_frontend_instance.public_ip
    description = "The public ip address assigned by AWS"
}
output "frontend_private_ip"{
    value       = aws_instance.ec2_frontend_instance.private_ip
    description = "The internal ip address assigned by AWS"
}
output "frontend_private_key" {
    value       = tls_private_key.this[0].private_key_pem
    sensitive   = true
    description = "The private key to access the EC2 instance"
}
