locals {
  instance_type = {
    prod = "t3.medium"
    dev = "t2.micro"
  }
}


resource "aws_instance" "ec2" {
    instance_type = local.instance_type[terraform.workspace]
    ami = "ami-00111452cb3c5dda0"
}

output "ec2_id" {
  value = aws_instance.ec2.id
}