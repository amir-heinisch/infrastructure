#
# Variables for my personal github account terraform stuff.
#
# author: Amir Heinisch <mail@amir-heinisch.de>
# filename: personal/variables.tf
# version: 01/01/2021
#

variable "github_url" {
  type = string
  description = "The github server to use. Only needed for custom enterprise servers."
  default = "https://github.com/"
  sensitive = false
}

variable "github_username" {
  type = string
  description = "The github username to use."
  default = "amir-heinisch"
  sensitive = false
}

variable "github_token" {
  type = string
  description = "A valid github access token to authenticate with."
  sensitive = true
}
