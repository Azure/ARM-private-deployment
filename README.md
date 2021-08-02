# Deploying ARM Templates with Linked Templates from a Private Repository

This repository contains documentation and sample code for deploying an ARM template which references additional nested templates from a private Azure Devops or Github repository by uploading as an Azure Template Spec and then triggering a build of the Azure Template Spec.

> Please note the Azure Template Specs are currently in [Public Preview](https://techcommunity.microsoft.com/t5/azure-governance-and-management/arm-template-specs-is-now-public-preview/ba-p/2103322).

## Sample ARM Template

This repository contains a sample ARM template which deploys:
- A network interface
- A network security group
- A virtual network
- A public IP address
- A virtual machine (default SKU Standard B2s)

This is just to use to demonstrate a deployment from a private repository using Azure Template Specs and should be replaced with your desired template. It is based on the [Simple Linux Virtual Machine Quickstart](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.compute/vm-simple-linux).

The sample ARM template also utilises a linked template to demonstrate that linked templates are also uploaded to the Azure Template Spec.

## Scripts

There are three scripts which are utilised by the GitHub workflow or Azure Devops Pipeline to deploy to Azure using Azure Template Specs:
1. Create Resource Group. <br>
   This script creates the Resource Group for the template specs, by default in the workflow or pipeline it creates a Resource Group called template-specs but this can be updated in the GitHub workflow.
2. Create the Azure Template Spec. <br>
   This script creates the Azure Template Spec from the ARM templates in the templates directory. The Template Spec created is called arm-private-deployment-ts and is versioned v0.1, these can both be updated in the workflow or pipeline.
3. Deploy the Azure Template Spec. <br>
   This script deploys the infrastructure defined in the Template Spec created by the previous step. By default it deploys the infrastructure in a Resource Group called arm-private-deployment - this can be updated in the workflow or pipeline.

# How to Set Up This Example

1. Start by creating a copy of this repository in your own account or organization by clicking the **Use this Template**.

![Use this Template button](/images/useTemplate.png)

2. Add a name and description for the new repository and set the visibility of the repository. Then click **Create repository from template**.

![Create repository from template](/images/create.png)

1. Replace the templates in the **templates** directory or use the example ARM template provided.

## GitHub Actions
### Pre-requisites
#### Create Service Principal
This implementation will require a Service Principal which your workflow will use to authenticate with Azure to deploy the resources
- Log in to the required Azure Active Directory Tenant using the Azure CLI on your local device or via [Azure Cloud Shell](https://shell.azure.com): <br>
`az login --tenant [Tenant ID]`
- Select the target Platform Subscription, inserting the Subscription ID where indicated: <br> `az account set --subscription [Subscription ID]`
- Create the Service Principal, providing an identifying name where indicated: <br> `az ad sp create-for-rbac --name [SP Name] --sdk-auth`
- Take a note of the json output for later use. It is recommended that you do not persist this information to disk or share the client secret for security reasons.

### Set Up the GitHub Workflow

1. Navigate to **Settings** -> **Secrets** -> **New repository secret** and add a new secret named **AZURE_CREDENTIALS**. Add the json output which was noted from the Service Principal creation as the secret value. Example output below for reference:

```
{
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    (...)
}
```

2. Navigate to **Actions** -> **arm-private-deployment**.
3. Click **Run workflow**, select the desired branch and click the **Run workflow** button.

## Azure DevOps Pipeline

1. This implementation will require a Service Connection in Azure Devops to authenticate with Azure to deploy the resources. If a suitable Service Connection is not available please create one using the steps documented [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#create-a-service-connection).

2. In your Azure Devops organization, navigate to Pipelines and select New Pipeline.

![New Pipeline](/images/new_pipeline.png)

3. Select GitHub for the source code location.

![New Pipeline](/images/github_pipeline_source.png)

4. If you have not authorized Azure DevOps to access GitHub you can do that now by authorizing Azure Pipelines as shown below. This will not be required if you have already authorized Azure Devops to access GitHub.

![Azure Pipeline Auth banner](/images/OAuth.png)
![Auth button](/images/Auth.png)

5. Select your copy of this repository. The pipeline file should automatically be selected.

6. Open the variables side panel and add a variable called "armConnection" with a value of the name of the service connection noted in step 1.

> You can also change the vmImage if you do not have an Ubuntu Azure Devops runner. You will need to ensure that the runner has the Azure CLI installed if it's a self-hosted runner.

8. Save and run the pipeline.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
