resource "aws_eip" "eip" {
  domain = "vpc"
#   instance = module.EC2.ec2_id
  instance = var.ec2_id
}

# output "eip_ip" {
# #   value = aws_eip.eip.
# }

variable "ec2_id" {
  
}