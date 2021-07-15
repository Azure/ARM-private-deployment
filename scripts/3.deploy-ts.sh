#!/bin/bash

exit_with_error() {
  echo -e "Usage: $0\n" \
    "flag value                                    description\n" \
    "-r   {RESOURCE_GROUP}                         Name of the resource group for the deployment.\n" \
    "-l   {LOCATION}                               Location for the deployment.\n" \
    "-t   {TEMPLATE_SPEC_RESOURCE_GROUP}           Name of the resource group containing the Template Spec.\n" \
    "-n   {TEMPLATE_SPEC_NAME}                     Name of the Template Spec to deploy\n" \
    "-v   {VERSION}                                Version number to use for template specs i.e. 1.0.\n" 1>&2
  exit 1
}

while getopts :r:v:n:h:t:l: option
do
  case "${option}"
    in
      r) rg=${OPTARG};;
      v) version=${OPTARG};;
      n) template_spec=${OPTARG};;
      t) template_spec_rg=${OPTARG};;
      l) location=${OPTARG};;
      h) exit_with_error;;
      :) exit_with_error;;
      *) exit_with_error;;
  esac
done

if [ $(az group exists --name $rg -o tsv) = false ]; then
  az group create \
    --name "$rg" \
    --location "$location"
fi

id=$(az ts show --name "$template_spec" --resource-group "$template_spec_rg" --version "$version" --query "id" -o tsv)

az deployment group create \
  --resource-group "$rg" \
  --name "arm-private-deployment" \
  --template-spec "$id" \
  --output json
