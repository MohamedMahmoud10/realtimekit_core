#!/usr/bin/env bash

set -euxo pipefail

LATEST_TAG="latest-android"
VERSION_NAME=$(date +%Y%m%d-%H%M%S)
APK_PATH="${1:?}"
FILE_PATH="flutter-ui-kit-${VERSION_NAME}.apk"
ASSET_URL="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/snapshots/${VERSION_NAME}/${FILE_PATH}"

function overwrite_local_tag() {
  git tag -f "${LATEST_TAG}"
}

function overwrite_remote_tag() {
  git push -f origin "${LATEST_TAG}"
}

function has_release() {
  curl --silent --fail --output /dev/null \
    --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
    "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/releases/${LATEST_TAG}"
}

function delete_release() {
  curl --silent --fail --request DELETE \
    --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
    "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/releases/${LATEST_TAG}"
}

function create_release() {
  curl --silent --fail --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
    --upload-file "${FILE_PATH}" \
    "${ASSET_URL}"

  curl --silent --fail --request POST \
    --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "{
      \"name\": \"Flutter UI Kit - Latest snapshot build\",
      \"tag_name\": \"${LATEST_TAG}\",
      \"description\": \"Latest snapshot build (${VERSION_NAME})\",
      \"assets\": {
        \"links\": [{
          \"name\": \"${FILE_PATH}\",
          \"url\": \"${ASSET_URL}\",
          \"link_type\": \"package\"
        }]
      }
    }" \
    "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/releases"
}

mv -v "${APK_PATH}" "${FILE_PATH}"

overwrite_local_tag

overwrite_remote_tag

if has_release; then
  delete_release
fi

create_release
