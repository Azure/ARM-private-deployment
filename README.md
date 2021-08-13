# Deploying ARM Templates with Linked Templates from a Private Repository

Previously, deploying ARM templates which contain links to additional templates required linked templates to be publicly accessible. This is because when the top level ARM template is submitted to Azure Resource Manager, the linked templates are not automatically uploaded and therefore need to pulled in at deploy time from Azure. This means they must be referenced using a URL which can be accessed from Azure (e.g. via a public GitHub repository). [Azure Template Specs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs) removes this requirement, as all required templates can be uploaded as Azure Template Specs which are then privately available within your subscription at deploy time.

This repository contains documentation and sample pipelines for creating an Azure Template Spec from an ARM template (including any linked templates) and then deploying the Azure Template Spec to build the infrastructure defined in the ARM template.

## Sample ARM Template

This repository contains a sample ARM template which deploys a storage account via a linked template. This is just to demonstrate a deployment from a private repository using Azure Template Specs and should be replaced with your desired template.

The sample ARM template utilises a linked template to demonstrate that linked templates are also uploaded as part of an Azure Template Spec.

## Scripts

There are three scripts which are utilised by the GitHub workflow or Azure DevOps Pipeline to deploy to Azure using Azure Template Specs:

1. Create Resource Group. <br>
   This script creates the Resource Group for the Template Specs, by default it creates a Resource Group called *template-specs* but this can be updated in the workflow or pipeline.
2. Create the Azure Template Spec. <br>
   This script creates the Azure Template Spec from the ARM templates in the templates directory. The Template Spec created is called *arm-private-deployment-ts* and is versioned as *v0.1*, these can both be updated in the workflow or pipeline.
3. Deploy the Azure Template Spec. <br>
   This script deploys the infrastructure defined in the Template Spec created by the previous step. By default it deploys the infrastructure in a Resource Group called *arm-private-deployment*. This can also be updated in the workflow or pipeline.

## How to set up this example

1. Start by creating a copy of this repository in your own account or organization by clicking the **Use this Template** button.

![Use this Template button](/images/useTemplate.png)

2. Add a name and description for the new repository and set the visibility of the repository. Then click the **Create repository from template** button.

![Create repository from template](/images/create.png)

3. Replace the templates in the **templates** directory or use the example ARM template provided.

## GitHub Actions

### Create a Service Principal

This implementation will require a Service Principal which your workflow will use to authenticate with Azure to deploy the resources.

- Log in to the required Azure Active Directory tenant using the Azure CLI on your local device or via [Azure Cloud Shell](https://shell.azure.com): <br>
`az login --tenant [Tenant ID]`
- Select the target platform subscription, inserting the subscription ID where indicated: <br> `az account set --subscription [Subscription ID]`
- Create the Service Principal, providing an identifying name where indicated: <br> `az ad sp create-for-rbac --role Contributor --name [SP Name] --sdk-auth`
- Take a note of the JSON output for later use. It is recommended that you do not persist this information to disk or share the client secret for security reasons.

### Set up the GitHub workflow

1. Navigate to **Settings** -> **Secrets** -> **New repository secret** and add a new secret named **AZURE_CREDENTIALS**. Add the JSON output which was noted from the Service Principal creation as the secret value. Example output below for reference:

```json
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

## Azure DevOps pipeline

### Create a Service Connection

This implementation will require a Service Connection in Azure DevOps to authenticate with Azure to deploy the resources. If a suitable Service Connection is not available please create one using the steps documented [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#create-a-service-connection).

> Note: The Resource Group option should be left empty, otherwise the Service Principal will only be able to deploy to that Resource Group and will not be able to deploy a new Resource Group to deploy either the example ARM template or the template it has been replaced with.

### Set up the pipeline

1. In your Azure DevOps organization, navigate to **Pipelines** and select **New pipeline**.

![New Pipeline](/images/new_pipeline.png)

2. Select GitHub for the source code location.

![GitHub pipeline source](/images/github_pipeline_source.png)

3. If you have not authorized Azure DevOps to access GitHub you can do that now by authorizing Azure Pipelines as shown below. This will not be required if you have already authorized Azure DevOps to access GitHub.

![Azure Pipeline Auth banner](/images/OAuth.png)
![Auth button](/images/Auth.png)

4. Select your copy of this repository. The pipeline file should automatically be selected.

5. Open the variables side panel and add a variable called **armConnection** with a value of the name of the service connection noted in step 1.

> You can also change the **vmImage** option if you do not have an Ubuntu Azure DevOps runner. You will need to ensure that the runner has the Azure CLI installed if it's a self-hosted runner.

6. Save and run the pipeline.

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
