#!/bin/bash
# Example: Save review output to a file after /review-branch completes
# Copy to .claude/hooks/after-review.sh and configure in settings

BRANCH=$(git branch --show-current)
OUTPUT_DIR="./review-artifacts/${BRANCH}"
mkdir -p "$OUTPUT_DIR"

# Copy the review output (customize path as needed)
if [ -f "./review-report.md" ]; then
  cp "./review-report.md" "$OUTPUT_DIR/review-$(date +%Y%m%d-%H%M%S).md"
  echo "Review saved to $OUTPUT_DIR"
fi
