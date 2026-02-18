---
name: fc-commit-message
description: Guidelines for writing clear and structured commit messages
---
# Commit Message Guidelines

Generate a markdown commit message using the following structure and formatting, including emojis and scopes.
Generate the raw markdown commit message, enclosed in quadruple backticks (````), and display it in the chat window.
Use `git diff` output to understand the changes made.

## 1. Title (First Line)

- Write a concise summary (50-72 characters max).
- Use imperative mood and present tense (e.g., "Add patient CRUD endpoints").
- Add a scope in parentheses after the emoji and before the title (e.g., ✨(patient): Add patient CRUD endpoints).
- Capitalize the first letter.
- Add a blank line after the title.

## 2. Summary Paragraph

- Write a 1-2 sentence summary of all relevant changes (100-200 characters).
- Focus on what and why, not how.
- Use present tense.
- Add a blank line after the summary.

## 3. Detailed Description

- Use section headers for major features/areas, each with a relevant emoji (e.g., ✨ for features, 🔧 for refactoring, 🖥️
  for UI, 🐛 for bug fixes, etc.).
- Under each section, use bullet points for detailed changes.
- Group related changes together. Mention file names or layers when appropriate.
- Explain the "why" behind significant changes.
- Reference issue numbers with #123 if applicable.
- Make the message clear, concise, and easy to understand.
- Adjust the length of the description to fit the changes made.
- Limit lines in the body to 72-80 characters for readability.
- Never use "WIP", "temp", or similar placeholders in commit messages.
- Clearly mark breaking changes with a section (e.g., ## 💥 Breaking Changes) and describe the impact.
- Reference related documentation, specs, or design docs if relevant.
- Optionally, include a checklist section for reviewers if the commit introduces new patterns,
  migrations, or requires special attention.

## 4. Remove unnecessary details

- Remove all `Co-authored-by` lines from the commit message, but keep or
  add this one `Co-authored-by: François Chastanet <237869+fchastanet@users.noreply.github.com>`
  at the end of the commit message preceded by a separator line.
- Remove any references to "WIP", "temp", or similar placeholders, as they do not provide meaningful
  information about the changes made.
- Remove any redundant or duplicate information that may be present in the stash commit messages,
  ensuring that the final message is concise and focused on the key changes.

## 5. Formatting Example

Follow the formatting, emoji usage, and scope tagging shown in the example below:
![Example Commit Message](references/example-commit-msg.md)

Do not include any explanations or additional text.
