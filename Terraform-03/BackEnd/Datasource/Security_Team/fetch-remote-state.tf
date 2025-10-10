data "terraform_remote_state" "fetch-state" {
    backend = "s3" 
        config = {
            bucket = "tf-datasource-bhvain-s3"
            region = "ap-south-1"
            key = "env/default.tfstate"
        }
    }