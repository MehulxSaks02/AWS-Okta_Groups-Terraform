r resource "okta_group" "example" {
  for_each = toset(var.okta_group_name)
  name        = each.key
  description = "${each.value} Group"
}

resource "okta_user_schema" "custom_attribute1"{
  index = "project"
  title = "Project"
  type = "string"
  required = false
}

resource "okta_user" "example" {
  for_each = var.okta_users

  first_name = each.value.first_name
  last_name  = each.value.last_name
  email      = each.value.email
  login      = each.value.login
  custom_profile_attributes = jsonencode(each.value.custom_attributes)

  group_memberships = [for group in var.user_group_assignments[each.key] : okta_group.example[group].id]
}

resource "okta_app_group_assignments" "aws_sso_app_assignments" {
  app_id   = "Enter your Okta Application (AWS SSO) ID here"  
  dynamic "group" {
    for_each = okta_group.example
    content {
      id = group.value.id
    }
  }
}
