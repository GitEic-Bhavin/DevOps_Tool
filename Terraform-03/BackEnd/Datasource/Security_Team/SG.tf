resource "aws_security_group" "sg_ds" {
    tags = {
        Name = "TF_DataSource_SG",
        Owner = "Bhavin"
    }
}

resource "aws_vpc_security_group_ingress_rule" "i-rule" {
    security_group_id = aws_security_group.sg_ds.id
    cidr_ipv4 = "${data.terraform_remote_state.fetch-state.outputs.eip_ip}/32"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

