#
# Configuration for my personal github account.
#
# author: Amir Heinisch <mail@amir-heinisch.de>
# filename: personal/personal.tf
# version: 01/01/2021
#

resource "github_user_ssh_key" "this" {
  title = replace(var.github_username, "-", "_")
  key   = file(join("", ["~/.ssh/keys/github/", replace(var.github_username, "-", "_"), "/id_rsa.pub"]))
}

resource "github_user_gpg_key" "this" {
  armored_public_key = "-----BEGIN PGP PUBLIC KEY BLOCK-----\n...\n-----END PGP PUBLIC KEY BLOCK-----"
}

resource "github_repository" "this" {
  for_each = toset([
    "dotfiles|My personal dotfiles.|public",
    "infrastructure|Some stuff which helps me with my infrastructure.|public",
    "amir-heinisch.github.io|Personal website.|public",
    "snippets|Some code in some languages.|public",
    "k8s-helm-charts|Some helm charts.|public"
  ])
  name        = element(split("|",each.value),0)
  description = element(split("|",each.value),1)
  visibility = element(split("|",each.value),2)
  auto_init = true
  gitignore_template = "Python"
  license_template = "mit"

  has_issues = false
  has_projects = false
  has_wiki = false
  is_template = false
  allow_merge_commit = false
  allow_squash_merge = false
  allow_rebase_merge = false
  delete_branch_on_merge = false
}

# TODO: Just as placeholder..find way to directly upload repo.
resource "github_branch" "dotfiles" {
  repository = "dotfiles"
  for_each = toset(["master","next","base","terminal","wayland","x11"])
  branch     = each.value
}
