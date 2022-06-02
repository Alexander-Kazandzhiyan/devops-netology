#terraform {
#  backend "s3" {
#    bucket = "netology-akazand-terraform-states"
#    encrypt = true
#    key = "main-infra/terraform.tfstate"
#    region = "us-east-1"
##    dynamodb_table = "terraform-locks"
#    }
#}
