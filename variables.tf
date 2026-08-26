variable "aws_region" {
  description = "AWS region where Atlas is deployed"
  type        = string
  default     = "eu-central-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default     = "034703319119"
}

variable "atlas_subnet_id" {
  description = "Existing subnet used by the Atlas EC2 instance"
  type        = string
  default     = "subnet-03bee819a93c43f80"
}

variable "atlas_ami_id" {
  description = "AMI used by the Atlas EC2 instance"
  type        = string
  default     = "ami-04bc554a9635a77c8"
}

variable "atlas_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "atlas_key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "atlas-ec2-key"
}
