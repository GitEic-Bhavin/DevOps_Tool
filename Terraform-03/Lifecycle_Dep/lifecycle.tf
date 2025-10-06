resource "aws_instance" "life" {
    # ami = "ami-00111452cb3c5dda0"
    ami = "ami-00284cad0b8123246"
    instance_type = "t2.micro"

    lifecycle {
    #   create_before_destroy = true
      ignore_changes = [ tags ]
        # create_before_destroy = true
    }
}