resource "aws_instance" "r-exec" {
    ami = "ami-00111452cb3c5dda0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    key_name = "remote-exec"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("/home/einfochips/Downloads/remote-exec.pem")
      host = self.public_ip

    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo apt-get update -y",
            "sudo apt-get install nginx -y"
         ]

         on_failure = continue
      
    }

    provisioner "local-exec" {
      command = <<EOT
        echo Your server pubilc ip is ${self.public_ip}
        curl http://${self.public_ip} 
      EOT
# This will fail the provisioner
      on_failure = continue # This will ignore error for curl http://vm_ip inside vm.
    }
      
}

# output "private_IP" {
#   value = aws_instance.life.private_ip
# }

resource "aws_security_group" "sg" {
  name = "remote-exec-SG_TF"
}

resource "aws_vpc_security_group_ingress_rule" "i-rule" {
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"

  security_group_id = aws_security_group.sg.id

}

resource "aws_vpc_security_group_ingress_rule" "s-rule" {
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"

  security_group_id = aws_security_group.sg.id

}

resource "aws_vpc_security_group_egress_rule" "o-rule" {
  security_group_id = aws_security_group.sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

}