#!/bin/bash
# Sync commit message instructions from skill to instructions file
# This script copies the content of skills/commit-message/SKILL.md
# to .github/commit-message.instructions.md while removing the skill frontmatter

set -e

SKILL_FILE="skills/commit-message/SKILL.md"
INSTRUCTIONS_FILE=".github/commit-message.instructions.md"
REFERENCE="skills/commit-message/references/example-commit-msg.md"
COMMIT_MSG_PROMPT="prompts/gpt-generate-commit-msg.prompt.md"
COMMIT_MSG_PROMPT_TEMPLATE="prompts.templates/gpt-generate-commit-msg.prompt.template.md"

trap 'rm -f "/tmp/template.tmp" || true' EXIT

if [ ! -f "$SKILL_FILE" ]; then
  echo "Error: $SKILL_FILE not found"
  exit 1
fi

# replace the markdown link with the file path
replace() {
local pattern="$1"
local file="$2"
local ref="$3"
awk -v ref="${ref}" "${pattern}"' {
    print "```markdown"
    while ((getline line < ref) > 0)
        print line
    close(ref)
    print "```"
    next
}
{ print }
' "${file}" > "/tmp/template.tmp" && mv "/tmp/template.tmp" "${file}"
}

# ----- .github/commit-message.instructions.md -------
# Extract content after the second --- (removing skill frontmatter)
# Keep the instructions file frontmatter
tail -n +$(awk '/^---$/{count++;if(count==2){print NR+1;exit}}' "$SKILL_FILE") \
    "$SKILL_FILE" > "/tmp/template.tmp"

# Prepend instructions file frontmatter
cp "/tmp/template.tmp" "$INSTRUCTIONS_FILE"
# remove eventual first blank line
sed -i '1{/^$/d}' "$INSTRUCTIONS_FILE"

replace \
    "/!\[Example Commit Message\]\(references\/example-commit-msg.md\)/" \
    "$INSTRUCTIONS_FILE" \
    "$REFERENCE"
echo "✓ Synced commit message instructions"

# ----- .github/prompts/gpt-generate-commit-msg.prompt.md -------
cp "${COMMIT_MSG_PROMPT_TEMPLATE}" "${COMMIT_MSG_PROMPT}"

replace \
    "/!\[Example Commit Message\]\(\/.github\/skills\/commit-message\/references\/example-commit-msg\.md\)/" \
    "${COMMIT_MSG_PROMPT}" \
    "$REFERENCE"
echo "✓ Synced commit message prompt"

# ----- prompts/compile-stash-commit-messages.prompt.md -------
cp "prompts.templates/compile-stash-commit-messages.template.md" "prompts/compile-stash-commit-messages.prompt.md"
# concat .github/commit-message.instructions.md to prompts/compile-stash-commit-messages.prompt.md
cat "$INSTRUCTIONS_FILE" >> "prompts/compile-stash-commit-messages.prompt.md"

echo "✓ Synced compile stash commit messages prompt"
