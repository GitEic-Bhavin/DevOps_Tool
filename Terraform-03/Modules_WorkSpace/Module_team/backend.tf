terraform {
  backend "s3" {
    bucket = "tf-backend-s3-bhavin"
    key    = "dev.tfstate" 
    region = "ap-south-1"
    
    # use_lockfile = true
  }
}