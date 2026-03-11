#!/bin/bash
# Example: Send a Slack notification after a review or fix completes
# Copy to .claude/hooks/notify.sh and configure in settings
#
# Requires: SLACK_WEBHOOK_URL environment variable

EVENT="${1:-unknown}"
BRANCH=$(git branch --show-current)
REPO=$(basename "$(git rev-parse --show-toplevel)")

MESSAGE="Claude Code: ${EVENT} completed on ${REPO}/${BRANCH}"

if [ -n "$SLACK_WEBHOOK_URL" ]; then
  curl -s -X POST "$SLACK_WEBHOOK_URL" \
    -H 'Content-Type: application/json' \
    -d "{\"text\": \"${MESSAGE}\"}" > /dev/null
  echo "Notification sent to Slack"
else
  echo "SLACK_WEBHOOK_URL not set — skipping notification"
fi
