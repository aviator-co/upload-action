#!/bin/bash

set -e

if [ -z "${AVIATOR_API_TOKEN}" ]; then
    echo "AVIATOR_API_TOKEN is required."
    exit 1
fi

if [ -z "${ASSETS}" ]; then
    echo "ASSETS is required."
    exit 1
fi

echo "Assets: $ASSETS"
all_files=()

for filename in ${ASSETS}; do
    if [ -f "$filename" ]; then
        all_files+=(-F "file[]=@$filename")
    fi
done

if [ "${#all_files[@]}" -eq 0 ]; then
    echo "No files found."
    exit 1
else
    echo "Files found: "
    echo "${all_files[@]}"
fi

if ! which curl > /dev/null; then
    echo "curl is required to use this command"
    exit 1
fi

if [[ -z "${AVIATOR_UPLOAD_URL}" ]]; then
    URL="https://upload.aviator.co/api/test-report-uploader"
else
    URL="${AVIATOR_UPLOAD_URL}"
fi

response=$(curl -X POST -H "x-Aviator-Api-Key: ${AVIATOR_API_TOKEN}" \
    -H "Provider-Name: github_action" \
    -H "Job-Name: ${GITHUB_JOB}" \
    -H "Workflow-Name: ${GITHUB_WORKFLOW}" \
    -H "Build-URL: $GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID" \
    -H "Build-ID: ${GITHUB_RUN_ID}_${GITHUB_RUN_NUMBER}" \
    -H "Commit-Sha: ${GITHUB_SHA}" \
    -H "Repo-Url: https://github.com/${GITHUB_REPOSITORY}" \
    -H "Branch-Name: ${GITHUB_REF_NAME}" \
    -F "file=@${FILE_PATH}" \
    "$URL")

echo "$response"
