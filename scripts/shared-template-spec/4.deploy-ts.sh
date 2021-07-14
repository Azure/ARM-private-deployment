#!/bin/bash

exit_with_error() {
  echo -e "Usage: $0\n" \
    "flag value                                    description\n" \
    "-r   {RESOURCE_GROUP}                         Name of the resource group to store the template specs.\n" \
    "-l   {LOCATION}                               The location to use for deployments.\n" \
    "-v   {VERSION}                                Version number to use for template specs i.e. 1.0.\n" \
    "-m   {MANAGEMENT_GROUP_COMPANY_PREFIX}        Value to use for the root management group.\n" \
    "-p   {PLATFORM_SUBSCRIPTION_ID}               The subscription ID / guid to use for the platform / hub.\n" \
    "-o   {ONLINE_LZ_SUBSCRIPTION_IDS}             The IDs to use for the Online LZs as a json array e.g. [\"id1\",\"id2\"]\n" \
    "-c   {CORP_LZ_SUBSCRIPTION_IDS}               The IDs to use for the Corp LZs as a json array e.g. [\"id1\",\"id2\"]\n" 1>&2
  exit 1
}

while getopts :r:l:v:m:p:o:c:h: option
do
  case "${option}"
    in
      r) rg=${OPTARG};;
      l) location=${OPTARG};;
      v) version=${OPTARG};;
      m) company_prefix=${OPTARG};;
      p) platformSubscriptionId=${OPTARG};;
      o) onlineSubsAsString="$OPTARG";;
      c) corpSubsAsString="$OPTARG";;
      h) exit_with_error;;
      :) exit_with_error;;
      *) exit_with_error;;
  esac
done

subscriptionSecurityConfigId=$(az ts show --name subscriptionSecurityConfig --resource-group "$rg" --version "$version" --query "id" -o tsv)
id=$(az ts show --name ent-scale --resource-group "$rg" --version "$version" --query "id" -o tsv)

echo "corp: $corpSubsAsString"
echo "online: $onlineSubsAsString"

az deployment tenant create \
  --name "${company_prefix}deploy" \
  --template-spec "$id" \
  --parameters \
    @deploy.parameters.json \
    enterpriseScaleCompanyPrefix="$company_prefix" \
    location="$location" \
    platformSubscriptionId="$platformSubscriptionId" \
    onlineLzSubscriptionId="$onlineSubsAsString" \
    corpLzSubscriptionId="$corpSubsAsString" \
    subscriptionSecurityConfigTemplateId="$subscriptionSecurityConfigId" \
  --location "$location" \
  --output json
