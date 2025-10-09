locals {
  instance_type = {
    prod = "t3.medium"
    dev = "t2.micro"
  }
}


resource "aws_instance" "ec2" {
    instance_type = "t2.micro"
    ami = "ami-00111452cb3c5dda0"
    vpc_security_group_ids = [var.sg_id]
}

output "ec2_id" {
  value = aws_instance.ec2.id
}

variable "sg_id" {
  
}
