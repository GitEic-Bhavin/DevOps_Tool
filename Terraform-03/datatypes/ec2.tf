# resource "aws_instance" "listec2" {
#     ami = "ami-02d26659fd82cf299"
#     instance_type = var.type_instance["ap-south-1"]
#     # instance_type = var.list_instnace[]
#     count = 2

#     tags = {
#       Name = "EC2${count.index}"
#     }
# }

# variable "list_instnace" {
#     type = list
#     default = ["m5.large", "m5.xlarge", "t2.medium"]
# }

# variable "type_instance" {
#     type = map
#     default = {
#         us-east-1 = "t2.micro"
#         ap-south-1 = "t2.nano"
#         us-east-2 = "t2.small"
#     }
# }

# # To create multiple users with diff name using count.index

# resource "aws_iam_user" "my-user" {
#   name = var.iam_user[count.index]
#   count = 4
# }

# variable "iam_user" {
#   type = list(string)
#   default = [ "john", "blob", "micheal", "rick" ]
# }

# # Conditional Expressions

# # conditions ? true_value:false_value

# resource "aws_security_group" "cond-exp" {
#     name = var.aws_sg_cond-Exp == "development" ? "developement_SG" : "qa_SG"
# }

# variable "aws_sg_cond-Exp" {
#   default = "development"
# }

# # Conditional Expressions with multiple variables

# # Only if env=prod and region=ap-south-1

# variable "region" {
#     default = "ap-south-2"
# }

# variable "env" {
#     default = "prod"
# }

# resource "aws_instance" "mult-var" {
#     instance_type = var.env == "prod" && var.region == "ap-south-1" ? "t3.medium" : "t2.micro"
#     ami = "ami-02d26659fd82cf299"
# }