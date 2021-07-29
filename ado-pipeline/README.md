# How to Set Up This Example Azure Devops Pipeline
## Pre-requisites 
### Create  Service Connection:
This implementation will require a Service Connection in Azure Devops to authenticate with Azure to deploy the resources. If a suitable Service Connection is not available please create one using the steps documented [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#create-a-service-connection). 

Take a note of the service connection name - this will be required later.

## Set Up the Azure Devops Pipeline

1. Install Azure Pipelines from Github Marketplace using the steps documented [here](https://www.azuredevopslabs.com/labs/vstsextend/github-azurepipelines/#:~:text=Task%201%3A%20Installing%20Azure%20Pipelines%20from%20GitHub%20Marketplace,include%20%28or%20All%20repositories%29%20and%20click%20Install.%20) if you do not already have Azure Pipelines installed.

2. In your Azure Devops organization, navigate to Pipelines and select New Pipeline:

![New Pipeline](/images/new_pipeline.png)

4. Select GitHub for the source code location:

![New Pipeline](/images/github_pipeline_source.png)

5. Select this repository, and then select to create the pipeline from an "Existing Azure Pipelines YAML file".
6. Ensure that the main branch is selected and select "/pipelines/ADO/azure-pipelines.yaml" as the path.
7. Open the variables side panel and add a variable called "armConnection" with a value of the name of the service connection noted in step 2.
> You can also change the vmImage if you do not have an Ubuntu Azure Devops runner. You will need to ensure that the runner has the Azure CLI installed if it's a self-hosted runner.
8. Save and run the pipeline.

