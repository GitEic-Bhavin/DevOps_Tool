resource "aws_instance" "hcp-ec2" {
    ami = "ami-00111452cb3c5dda0"
    instance_type = "t2.micro"

    tags = {
      Name = "HCF_EC2"
      Owner = "Bhavin"
    }
}

# Here, This will be push into git repo.
# The HashiCorp Cloud Plateform HCP will fetch this latest code from git repo and auto plan and apply.

# But, This much is not enough to create resource usig git.
# HCP will required AWS credentials bcz HCP is cloud SaaS Service.
# Thatsfor HCP is diff from terraform server where installed TF.

