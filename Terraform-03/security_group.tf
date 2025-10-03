resource "aws_security_group" "my-sg" {
  name        = "My_TFSG"
  description = "Just for testing by tf"
  # depends_on = [ aws_eip.lb ]
}

resource "aws_vpc_security_group_ingress_rule" "inbound_rule" {
  security_group_id = aws_security_group.my-sg.id
  # cidr_ipv4 = aws_vpc.main.cidr_block
  cidr_ipv4   = "${aws_eip.lb.public_ip}/32"
  from_port   = var.HTTPS_from
  to_port     = var.HTTPS_to
  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "outbound_rule" {
  security_group_id = aws_security_group.my-sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

}