# provider "aws" {
#     region = var.Region
# }

variable "Region" {
  default = "us-east-1"
}

# variable "tags" {
#   type = list
#   default = ["firstec2", "secondec2"]
# }

# variable "ami" {
#   type = map
#   default = {
#     "us-east-1" = "ami-0360c520857e3138f"
#     "us-west-1" = "ami-00271c85bf8a52b84"
#     "ap-south-1" = "ami-02d26659fd82cf299"
#   }
# }



# resource "aws_instance" "app-dev" {
#     ami = lookup(var.ami, var.Region)
#     instance_type = "t2.micro"
#     count = length(var.tags)

#     tags = {
#         Name = element(var.tags, count.index)
#         CreationDate = formatdate("DD MM YYYY hh::mm:ZZZ",timestamp())
#     }
# }

# data "aws_instance" "app-dev" {
# #   instance_id = "i-instanceid"
#     region = var.Region
# #   filter {
# #     name   = "image-id"
# #     values = ["ami-xxxxxxxx"]
# #   }

#   filter {
#     name   = "tag:Name"
#     values = ["secondec2"]
#   }
# }

data "local_file" "read" {
  filename = "${path.module}/demo.txt"
}

output "read-file" {
  value = data.local_file.read.content
}


# Fetch aws ami id for ubuntu in ap-south-1 regions.
data "aws_ami" "ami" {
  region = var.Region
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu-pro-minimal/images/hvm-ssd/ubuntu-jammy-amd64-pro-minimal-*"]
  }
}

output "ami-id" {
  value = data.aws_ami.ami.id
}

resource "aws_instance" "ref-ami-id" {
  ami = data.aws_ami.ami.image_id
  instance_type = "t2.micro"
}