provider "aws" {
    region = var.aws_regions
}

resource "aws_eip" "ex" {
    domain = var.domain_name
    tags = {
        Name = var.eip_name
    }
}
