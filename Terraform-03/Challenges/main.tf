resource "aws_iam_user" "iam" {
    name = "admin-user-${data.aws_caller_identity.current.account_id}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_users" "iu" {

}

# output "list_of_users" {
#     value = data.aws_iam_users.iu.names
# }

# output "Total_count_of_users" {
#     value = length(data.aws_iam_users.iu.names)
# }