resource "aws_instance" "atlas" {
  ami           = var.atlas_ami_id
  instance_type = var.atlas_instance_type

  subnet_id = data.aws_subnet.atlas.id

  vpc_security_group_ids = [
    aws_security_group.atlas_ec2.id
  ]

  key_name = var.atlas_key_name

  iam_instance_profile = "AtlasEC2Role"

  monitoring    = false
  ebs_optimized = false

  tags = {
    Name = "atlas-server"
  }
}
