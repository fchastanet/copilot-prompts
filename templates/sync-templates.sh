#!/bin/bash
# Sync commit message instructions from skill to instructions file
# This script copies the content of skills/commit-message/SKILL.md
# to .github/commit-message.instructions.md while removing the skill frontmatter

set -o pipefail -o errexit -o errtrace -o nounset

copy() {
  local src="$1"
  local dest="$2"
  cp "$src" "$dest"
}

replacePatternByFileUsingSed() {
  local pattern="$1"
  local file="$2"
  local ref="$3"
  sed -E -i "/${pattern}/r ${ref}" "${file}"
  sed -E -i "/${pattern}/d" "${file}"
}

trap 'rm -f "/tmp/example-commit-msg.tmp" || true' EXIT

# create a temporary file to store the content of .github/commit-message.instructions.md with fences
(
    echo
    echo '```markdown'
    cat "skills/commit-message/references/example-commit-msg.md"
    echo '```'
) > "/tmp/example-commit-msg.tmp"


copy "skills/commit-message/SKILL.md" ".github/commit-message.instructions.md"
replacePatternByFileUsingSed \
    "!\[Example Commit Message\]\(references\/example-commit-msg.md\)" \
    ".github/commit-message.instructions.md" \
    "/tmp/example-commit-msg.tmp"
# remove frontmatter from .github/commit-message.instructions.md
sed -i '/^---$/,/^---$/d' ".github/commit-message.instructions.md"
echo "✓ Synced commit message instructions"

copy "templates/gpt-generate-commit-msg.prompt.template.md" "prompts/gpt-generate-commit-msg.prompt.md"
replacePatternByFileUsingSed \
    "\{\.github\/commit-message\.instructions\.md\}" \
    "prompts/gpt-generate-commit-msg.prompt.md" \
    ".github/commit-message.instructions.md"
echo "✓ Synced commit message prompt"

copy "templates/compile-stash-commit-messages.prompt.template.md" "prompts/compile-stash-commit-messages.prompt.md"
replacePatternByFileUsingSed \
    "\{\.github\/commit-message\.instructions\.md\}" \
    "prompts/compile-stash-commit-messages.prompt.md" \
    ".github/commit-message.instructions.md"
echo "✓ Synced compile stash commit messages prompt"
