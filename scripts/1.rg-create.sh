#!/bin/bash

exit_with_error() {
  echo "Usage: $0 -r {RESOURCE_GROUP} -l {LOCATION}" 1>&2
  exit 1
}

while getopts r:l: option
do
  case "${option}"
    in
      r) rg=${OPTARG};;
      l) location=${OPTARG};;
      *) exit_with_error;;
  esac
done

if [ $(az group exists --name $rg -o tsv) = false ]; then
  az group create \
    --name "$rg" \
    --location "$location"
fi