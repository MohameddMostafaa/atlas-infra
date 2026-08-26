# Terraform outputs for the Atlas infrastructure.
output "atlas_instance_id" {
  description = "ID of the Atlas EC2 instance"
  value       = aws_instance.atlas.id
}

output "atlas_public_ip" {
  description = "Public IP address of the Atlas EC2 instance"
  value       = aws_instance.atlas.public_ip
}

output "atlas_private_ip" {
  description = "Private IP address of the Atlas EC2 instance"
  value       = aws_instance.atlas.private_ip
}

output "atlas_security_group_id" {
  description = "Security group ID used by Atlas"
  value       = aws_security_group.atlas_ec2.id
}

output "atlas_ec2_role_arn" {
  description = "IAM role ARN used by the Atlas EC2 instance"
  value       = aws_iam_role.atlas_ec2.arn
}

output "github_deploy_role_arn" {
  description = "IAM role ARN used by GitHub Actions deployments"
  value       = aws_iam_role.github_deploy.arn
}
