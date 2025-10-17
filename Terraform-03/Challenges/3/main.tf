provider "aws" {
    # version = "~> 2.54"
    region = "ap-south-1"
    access_key = ""
    secret_key = ""
}

provider "digitalocean" { 

}

terraform {
  required_version = "0.12.31"
}

# terraform {
#   required_providers {
#     digitalocean = {
#       source  = "digitalocean/digitalocean"
#       version = "~> 2.0"
#     }
#   }
# }

terraform {
  
}
resource "aws_eip" "ch-3" {
  # vpc = true
}