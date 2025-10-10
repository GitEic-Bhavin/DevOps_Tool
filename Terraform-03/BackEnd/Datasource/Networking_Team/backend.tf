terraform {
  backend "s3" {
    bucket = "tf-datasource-bhvain-s3"
    key = ""
    region = "ap-south-1"
  }
}