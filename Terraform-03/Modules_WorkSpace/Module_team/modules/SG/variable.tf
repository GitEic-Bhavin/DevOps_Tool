variable "myip_url" {
  default = "https://ipv4.icanhazip.com/"
}
variable "SSH_from_port" {
  default = 22
}
variable "SSh_to_port" {
  default = 22
}
variable "SSH_protocol" {
  default = "tcp"
}
variable "rds_from_port" {
  default = 3306
}
variable "rds_to_port" {
  default = 3306
}
variable "rds_protocol" {
  default = "tcp"
}

# variable "rds_sg" {
#     description = "take output of security group fork output.tf and use as input in rds block"
# }