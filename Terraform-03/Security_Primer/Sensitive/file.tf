# resource "local_file" "foo" {
#     content = var.passwd
#     filename = "passwd.txt"
# }

# variable "passwd" {
#     default = "password id xyz"
#     sensitive = true
# }

resource "local_sensitive_file" "bar" {
    filename = "password.txt"
    content = "passwd is xyz"
}

output "passwd_show" {
    value = local_sensitive_file.bar.content
    sensitive = true
}