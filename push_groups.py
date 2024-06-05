import requests
import os
import logging

logging.basicConfig(filename=os.path.join(os.getcwd(), 'push_groups.log'), level=logging.INFO, format='%(asctime)s %(message)s')

# okta_domain = os.getenv("OKTA_DOMAIN")
# api_token = os.getenv("OKTA_API_TOKEN")
# aws_sso_app_id = os.getenv("AWS_SSO_APP_ID")

okta_domain = "Enter your okta domain"
api_token = "Enter okta API token"
aws_sso_app_id = "Enter AWS SSO Application ID"

headers = {
    "Authorization": f"SSWS {api_token}",
    "Content-Type": "application/json"
}

def push_group(group_name):
    # Get the group ID by group name
    group_response = requests.get(
        f"https://{okta_domain}/api/v1/groups?q={group_name}",
        headers=headers
    )
    group_id = group_response.json()[0]['id']

    # Push group to the application
    push_payload = {
        "id": group_id  # Correct format: {"id": "groupId"}
    }
    push_response = requests.put(
        f"https://{okta_domain}/api/v1/apps/{aws_sso_app_id}/groups/{group_id}",
        headers=headers,
        json=push_payload
    )
    if push_response.status_code == 200:
        print(f"Successfully pushed group '{group_name}' to AWS SSO application.")
    else:
        print(f"Failed to push group '{group_name}': {push_response.text}")


if __name__ == "__main__":
    groups = ["test-group1","test-group2"]
    for group in groups:
        push_group(group)
