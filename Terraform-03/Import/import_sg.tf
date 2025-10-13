provider "aws" {
  region = "us-east-1"

}

import {
  to = aws_security_group.my-existing-sg
  id = "sg-091465a33e51d9a0f"
}