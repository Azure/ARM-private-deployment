#!/bin/bash

exit_with_error() {
  echo "Usage: $0 -r {RESOURCE_GROUP} -l {LOCATION} -v {VERSION}" 1>&2
  exit 1
}

while getopts r:l:v: option
do
  case "${option}"
    in
      r) rg=${OPTARG};;
      l) location=${OPTARG};;
      v) version=${OPTARG};;
      *) exit_with_error;;
  esac
done

az ts create \
  --name ent-scale \
  --version "$version" \
  --resource-group "$rg" \
  --location "$location" \
  --template-file "./deploy.json" \
  --yes