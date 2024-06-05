variable "okta_org_name" {
  type = string
  default = "Enter your okta organization name"
}

variable "okta_base_url" {
  type = string
  default = "Enter your okta base url"
}

variable "okta_group_name" {
    type = list
    description = "list of okta groups"
    default = ["test-group1", "test-group2"]
}

variable "okta_users" {
  type = map(object({
    first_name      = string
    last_name       = string
    email           = string
    login           = string
    custom_attributes = map(string)
  }))
  description = "Map of users to create with custom attributes"
  default = {
    user1 = {
      first_name = "John"
      last_name  = "Doe"
      email = "john.doe@gmail.com"
      login = "john.doe@gmail.com"
      custom_attributes = {
        department = "Engineering"
        title      = "Engineer"
        project = "Integrations"
      }
    }
    user2 = {
      first_name = "Anand"
      last_name = "K"
      email = "anand.k@gmail.com"
      login = "anand.k@gmail.com"
      custom_attributes = {
        department = "Integrations"
        title = "Analyst"
        project = "OMS"
      }
    }
    user3 = {
      first_name = "M"
      last_name = "Fouzan"
      email = "m.fouzan@gmail.com"
      login = "m.fouzan@gmail.com"
      custom_attributes = {
        department = "Platform"
        title = "Analyst"
        project = "RPA"
      }
    }
  }
}

variable "user_group_assignments" {
  type = map(list(string))
  description = "Map of user keys to list of group names they should be assigned to"
  default = {
    user1 = ["test-group1"]
    user2 = ["test-group2"]
    user3 = ["test-group2"]
  }
}
