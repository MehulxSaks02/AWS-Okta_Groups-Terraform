resource "okta_group" "example" {
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

resource "null_resource" "push_groups" {
  provisioner "local-exec" {
    command = "python3 push_groups.py"
    environment = {
      OKTA_DOMAIN     = "${var.okta_org_name}.${var.okta_base_url}"
      OKTA_API_TOKEN  = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["api_token"]
      AWS_SSO_APP_ID  = "0oahc4vzl9WLWQux55d7"  # Replace with your actual AWS SSO app ID
      GROUP_NAMES     = join(",", var.okta_group_name)
    }
  }

  depends_on = [okta_app_group_assignments.aws_sso_app_assignments]
}
