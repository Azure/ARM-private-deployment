# How to Set Up the GitHub Workflow
# How to Set Up This Example Azure Devops Pipeline
## Pre-requisites 
### Create Service Principal
This implementation will require a Service Principal which your workflow will use to authenticate with Azure to deploy the resources
- Log in to the required Azure Active Directory Tenant using the Azure CLI on your local device or via [Azure Cloud Shell](https://shell.azure.com): <br>
`az login --tenant [Tenant ID]`
- Select the target Platform Subscription, inserting the Subscription ID where indicated: <br> `az account set --subscription [Subscription ID]`
- Create the Service Principal, providing an identifying name where indicated: <br> `az ad sp create-for-rbac --name [SP Name] --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`
- Take a note of the values of **client_id**, **client_secret** and **tenant_id** for later use. It is recommended that you do not persist this information to disk or share the client secret for security reasons.

## Set Up the GitHub Workflow

1. Navigate to **Settings** -> **Secrets** -> **New repository secret** and add each of the following secrets:

| Secret Name              | Example Value                        | Description |
| ------------------------ | ------------------------------------ | ----------- |
| SP_APP_ID | 9505fb9a-96e6-46d1-ac9b-2f74ee57f6d6 | Client ID from the [Service Principal creation](###create-service-principal) |
| SP_PASSWORD | [secure string] | Client Secret from the [Service Principal creation](###create-service-principal) |
| SUBSCRIPTION_ID | 3edb65d1-d7a8-409b-a320-3c01ac6825f9 | Subscription ID to deploy to |
| TENANT | f7d23806-d8ac-4576-814f-0ee931ffeab3 | Azure AD Tenant ID from the [Service Principal creation](###create-service-principal) |

2. Navigate to **Actions** -> **arm-private-deployment**.
3. Click **Run workflow**, select the desired branch and click the **Run workflow** button.

