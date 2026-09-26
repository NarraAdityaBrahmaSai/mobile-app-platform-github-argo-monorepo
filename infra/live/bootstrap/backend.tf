# Bootstrap intentionally uses local state for its first apply.
# After bootstrap, protect the bootstrap state separately or move it
# to a dedicated administrative state account.
terraform {
  backend "local" {}
}
