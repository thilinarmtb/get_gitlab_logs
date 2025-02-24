#!/bin/bash

source ./secrets.data

# GitLab API endpoint to list pipelines.
PIPELINE_URL="${SECRET_PROJ_URL}/pipelines"

# Make the request to list pipelines.
response=$(curl --silent --header \
  "PRIVATE-TOKEN: ${SECRET_PROJ_ACCESS_TOKEN}" \
  "${PIPELINE_URL}")

# Extract pipeline IDs
pipeline_ids=$(echo "$response" | jq -r '.[].id')

# Print pipeline IDs
echo "Pipeline IDs:"
for id in $pipeline_ids; do
  echo "$id"
done
