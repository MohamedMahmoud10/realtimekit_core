#!/bin/bash
set -euo pipefail

# All required variables should be passed as environment variables:
# - RUN_URL
# - WORKFLOW_NAME
# - REPOSITORY
# - BRANCH
# - ACTOR
# - NOTIFY_WEBHOOK

if [ -z "${NOTIFY_WEBHOOK:-}" ]; then
	echo "Error: NOTIFY_WEBHOOK environment variable is not set"
	exit 1
fi

payload="{\"text\": \"🚨 *Release Build Failure*\n\n*Workflow:* ${WORKFLOW_NAME}\n*Repository:* ${REPOSITORY}\n*Branch:* ${BRANCH}\n*Triggered By:* ${ACTOR}\n\n<${RUN_URL}|View Build Logs>\"}"

curl --fail -X POST "$NOTIFY_WEBHOOK" \
	-H "Content-Type: application/json; charset=UTF-8" \
	-d "$payload"

echo "Failure notification sent to webhook"
