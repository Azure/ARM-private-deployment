#!/bin/bash

exit_with_error() {
  echo -e "Usage: $0\n" \
    "flag value                                    description\n" \
    "-r   {RESOURCE_GROUP}                         Name of the resource group to store the template specs.\n" \
    "-l   {LOCATION}                               The location to use for deployments.\n" \
    "-v   {VERSION}                                Version number to use for template specs i.e. 1.0.\n" 1>&2
  exit 1
}

while getopts :r:l:v:h: option
do
  case "${option}"
    in
      r) rg=${OPTARG};;
      l) location=${OPTARG};;
      v) version=${OPTARG};;
      h) exit_with_error;;
      :) exit_with_error;;
      *) exit_with_error;;
  esac
done

id=$(az ts show --name ent-scale --resource-group "$rg" --version "$version" --query "id" -o tsv)

az deployment tenant create \
  --name "arm-private-deployment" \
  --template-spec "$id" \
  --parameters \
    location="$location" \
  --location "$location" \
  --output json
