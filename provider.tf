provider "aws" {
  region = var.region

  dynamic "assume_role" {
    for_each = var.assume_role_arn == null ? [] : [var.assume_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(var.tags, { AccessScope = var.access_scope })
  }
}

data "aws_caller_identity" "this" {}
