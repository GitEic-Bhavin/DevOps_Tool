resource "aws_instance" "myec2" {
  ami           = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"

  tags = {
    Name = "EC2-1"
  }
}

output "ec2-public_ip" {
  value = aws_instance.myec2.public_ip
}