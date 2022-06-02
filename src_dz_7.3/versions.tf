terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


#terraform {
#  backend "s3" {
#    bucket = "terraform-states"
#    encrypt = true
#    key = "main-infra/terraform.tfstate"
#    region = "us-east-1"
#    dynamodb_table = "terraform-locks"
#    }
#}
