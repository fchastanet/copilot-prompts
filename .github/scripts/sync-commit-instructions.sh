#!/bin/bash
# Sync commit message instructions from skill to instructions file
# This script copies the content of .github/skills/commit-message/SKILL.md
# to .github/commit-message.instructions.md while removing the skill frontmatter

set -e

SKILL_FILE=".github/skills/commit-message/SKILL.md"
INSTRUCTIONS_FILE=".github/commit-message.instructions.md"

trap 'rm -f "$INSTRUCTIONS_FILE.tmp" || true' EXIT

if [ ! -f "$SKILL_FILE" ]; then
  echo "Error: $SKILL_FILE not found"
  exit 1
fi

# Extract content after the second --- (removing skill frontmatter)
# Keep the instructions file frontmatter
tail -n +$(awk '/^---$/{count++;if(count==2){print NR+1;exit}}' "$SKILL_FILE") "$SKILL_FILE" > "$INSTRUCTIONS_FILE.tmp"

# Prepend instructions file frontmatter
cp "$INSTRUCTIONS_FILE.tmp" "$INSTRUCTIONS_FILE"
# remove eventual first blank line
sed -i '1{/^$/d}' "$INSTRUCTIONS_FILE"

echo "✓ Synced commit message instructions"
