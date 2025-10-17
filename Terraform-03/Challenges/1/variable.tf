variable "instance_config" {
  type = map(any)
  default = {
    instance1 = { instance_type = "t2.micro", ami = "ami-00111452cb3c5dda0" },
    instance2 = { instance_type = "t2.medium", ami = "ami-00111452cb3c5dda0" }
  }
}