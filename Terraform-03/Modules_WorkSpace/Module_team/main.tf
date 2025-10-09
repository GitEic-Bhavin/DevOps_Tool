provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias = "west"
  region = "us-west-2"
  
}

provider "aws" {
  alias = "mumbai"
  region = "ap-south-1"
}

module "security-group" {
  source = "./modules/SG"

# # Define provider explicitly in root module to pass into that module's child modules.
#   providers = {
#     aws = aws.west 
#   }
# }

providers = {
  aws.mumbai = aws.mumbai
  }
}

module "default-vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/EC2"
  sg_id = module.security-group.sg_id
}


module "eip" {
  source = "./modules/EIP"
  ec2_id = module.ec2.ec2_id
}