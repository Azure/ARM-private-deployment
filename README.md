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

For details on how to run the sample Azure Devops Pipeline or GitHub Workflow please see the documentation in the [ado-pipeline](./ado-pipeline/README.md) or [.github](./.github/README.md) directories.

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
