# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sg-091465a33e51d9a0f"
resource "aws_security_group" "my-existing-sg" {
  description = "SingleNodeK8sSG created 2025-07-18T06:24:36.396Z"
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "OutBound Rule"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "For Ping"
    from_port        = -1
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "icmp"
    security_groups  = []
    self             = false
    to_port          = -1
    },

    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "HTTPS Allow"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
      }, {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "API Server Kubectl Access"
      from_port        = 6443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 6443
      }, 
      
      {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "NodePort Service Range"
      from_port        = 30000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 32767
      }, 
      
      {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "kubelet API health check"
      from_port        = 10250
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 10250
      }, 
      
      {
      cidr_blocks      = ["115.112.142.34/32"]
      description      = "SSH ALlow"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22

  }]

  name                   = "SingleNodeK8sSG"
  name_prefix            = null
  region                 = "us-east-1"
  revoke_rules_on_delete = null
  tags                   = {}
  tags_all               = {}
  vpc_id                 = "vpc-0bf7cfa17cc560594"
}
