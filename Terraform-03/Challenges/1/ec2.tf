resource "aws_instance" "map" {

	  for_each      = var.instance_config
	  instance_type = each.value.instance_type
  ami           = each.value.ami
}

#  To use of map variable to create ec2 with var of ami and instance_type.
# We should use for_each loop with iterate over vars "instance_config" and put value on attributes instance_type via instance_type = each.value.instance_type

