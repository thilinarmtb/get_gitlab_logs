#!/bin/bash

source ./secrets.data

# GitLab pipeline ID
PIPELINE_ID="$1"
# Directory to save the logs
LOG_DIR="pipeline_logs"

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to get all jobs in a given pipeline
get_pipeline_jobs() {
    curl --header "PRIVATE-TOKEN: ${SECRET_PROJ_ACCESS_TOKEN}" \
         "${SECRET_PROJ_URL}/pipelines/${PIPELINE_ID}/jobs"
}

# Function to download the log of a given job
download_job_log() {
  local job_id=$1
  local job_name=$2
  curl --header "PRIVATE-TOKEN: ${SECRET_PROJ_ACCESS_TOKEN}" \
    "${SECRET_PROJ_URL}/jobs/${job_id}/trace" \
    -o "${LOG_DIR}/${job_id}_${job_name}.txt"
  echo "Downloaded log for job ${job_name} (ID: ${job_id})"
}

# Function to download job artifacts
download_job_artifacts() {
  local job_id=$1
  local job_name=$2
  curl --header "PRIVATE-TOKEN: ${SECRET_PROJ_ACCESS_TOKEN}" \
    "${SECRET_PROJ_URL}/jobs/${job_id}/artifacts" \
    -o "${LOG_DIR}/${job_id}_${job_name}.zip"
  echo "Downloaded artifacts for job ${job_name} (ID: ${job_id})"
}

# Get the list of jobs in the pipeline
jobs=$(get_pipeline_jobs)

# Extract job IDs and names from the jobs list and download their logs
echo "$jobs" | jq -c '.[]' | while read -r job; do
  job_id=$(echo "${job}" | jq -r '.id')
  job_name=$(echo "${job}" | jq -r '.name')
  download_job_log "${job_id}" "${job_name}"
  download_job_artifacts "${job_id}" "${job_name}"
done
