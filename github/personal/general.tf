#
# General configuration for terraform.
#
# author: Amir Heinisch <mail@amir-heinisch.de>
# filename: personal/general.tf
# version: 01/01/2021
#

terraform {
  required_version = ">= 0.14.3"
  required_providers {
    github = {
      source  = "hashicorp/github"
      version = ">= 4.1.0"
    }
  }
}

provider "github" {
  base_url = var.github_url
  owner = var.github_username
  token = var.github_token
}
