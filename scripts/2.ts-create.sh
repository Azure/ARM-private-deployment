#!/bin/bash

exit_with_error() {
  echo "Usage: $0 -r {RESOURCE_GROUP} -l {LOCATION} -v {VERSION} -t {PATH_TO_TEMPLATE_FILE} -n {TEMPLATE_NAME}" 1>&2
  exit 1
}

while getopts r:l:v:t:n: option
do
  case "${option}"
    in
      r) rg=${OPTARG};;
      l) location=${OPTARG};;
      v) version=${OPTARG};;
      t) template_path=${OPTARG};;
      n) template_name=${OPTARG};;
      *) exit_with_error;;
  esac
done

az ts create \
  --name "$template_name" \
  --version "$version" \
  --resource-group "$rg" \
  --location "$location" \
  --template-file "$template_path" \
  --yes