resource "aws_eip" "eip-tf" {
    domain = "vpc"

    tags = {
      Name = "${terraform.workspace}-eip",
      Owner = "Bhavin"
    }
}

output "eip_ip" {
    value = aws_eip.eip-tf.public_ip
}