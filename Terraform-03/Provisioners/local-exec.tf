# resource "aws_instance" "life" {
#     ami = "ami-00111452cb3c5dda0"
#     instance_type = "t2.micro"

#     provisioner "local-exec" {
#       command = "echo ${self.private_ip} > private_IP.txt"
#     }
# }

# output "private_IP" {
#   value = aws_instance.life.private_ip
# }