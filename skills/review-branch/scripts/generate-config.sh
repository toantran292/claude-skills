#!/bin/bash
# Scan current directory for git repos and generate review-config.json
# Usage: bash generate-config.sh [base-dir]

BASE_DIR="${1:-.}"
CONFIG_DIR="${BASE_DIR}/claude-context"
CONFIG_FILE="${CONFIG_DIR}/review-config.json"

mkdir -p "$CONFIG_DIR"

echo "Scanning for git repos in: $(cd "$BASE_DIR" && pwd)"

repos="["
first=true

for dir in "$BASE_DIR"/*/; do
  [ -d "$dir/.git" ] || continue
  name=$(basename "$dir")

  # Detect tech stack
  stack=""
  if [ -f "$dir/Gemfile" ]; then
    stack="Ruby"
    grep -q "sequel" "$dir/Gemfile" 2>/dev/null && stack="$stack + Sequel"
    grep -q "pg\|postgres" "$dir/Gemfile" 2>/dev/null && stack="$stack + Postgres"
    grep -q "sidekiq" "$dir/Gemfile" 2>/dev/null && stack="$stack + Sidekiq"
    grep -q "rails" "$dir/Gemfile" 2>/dev/null && stack="Rails + $stack"
  elif [ -f "$dir/package.json" ]; then
    stack="Node.js"
    grep -q "nestjs\|@nestjs" "$dir/package.json" 2>/dev/null && stack="NestJS"
    grep -q "prisma" "$dir/package.json" 2>/dev/null && stack="$stack + Prisma"
    grep -q "next" "$dir/package.json" 2>/dev/null && stack="Next.js"
    grep -q "react" "$dir/package.json" 2>/dev/null && stack="$stack + React"
    grep -q "vue" "$dir/package.json" 2>/dev/null && stack="$stack + Vue"
  elif [ -f "$dir/go.mod" ]; then
    stack="Go"
  elif [ -f "$dir/requirements.txt" ] || [ -f "$dir/pyproject.toml" ]; then
    stack="Python"
  fi

  [ -z "$stack" ] && stack="Unknown"

  if [ "$first" = true ]; then
    first=false
  else
    repos="$repos,"
  fi
  repos="$repos
    { \"name\": \"$name\", \"path\": \"./$name\", \"tech_stack\": \"$stack\" }"
done

repos="$repos
  ]"

cat > "$CONFIG_FILE" << HEREDOC
{
  "repos": $repos,
  "default_tech_stack": "Auto-detected per repo",
  "deployment_env": "AWS ECS, RDS"
}
HEREDOC

echo "Generated: $CONFIG_FILE"
echo "Found $(echo "$repos" | grep -c '"name"') repo(s)"
cat "$CONFIG_FILE"