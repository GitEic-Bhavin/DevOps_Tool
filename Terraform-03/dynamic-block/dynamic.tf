resource "aws_security_group" "dynamic" {
  name = "Sample-SG-TF"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8204
    to_port     = 8204
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}


variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [8200, 8201, 9000, 9200]
}

resource "aws_security_group" "dyn-sg" {
  name = "Dynamic_SG_TF"

  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}

resource "aws_instance" "dy-ec2" {
  instance_type          = "t2.micro"
  ami                    = "ami-00111452cb3c5dda0"
  vpc_security_group_ids = [aws_security_group.dyn-sg.id]
}

resource "aws_iam_user" "iam-u" {
  count = 3
  name  = "user-${count.index}"
  path  = "/system/"
}

output "arns-iam" {
  value = aws_iam_user.iam-u[*].arn
}