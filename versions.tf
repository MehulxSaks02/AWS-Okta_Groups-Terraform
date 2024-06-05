terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.51.1"
    }

    okta = {
      source = "okta/okta"
      version = "~> 3.41"
    }
  }
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.token.arn
}
data "aws_secretsmanager_secret" "token" {
  name = "Okta-AWS_SSO-Token"
}

provider "okta" {
  org_name = var.okta_org_name
  base_url = var.okta_base_url
  api_token  = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["api_token"]
}

provider "aws" {
  region = "us-east-1"
  access_key = "Enter your access key here"
  secret_key = "Enter your secret access key here"
}
