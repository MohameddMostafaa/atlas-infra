data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "atlas" {
  id = var.atlas_subnet_id
}
