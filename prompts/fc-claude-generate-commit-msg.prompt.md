---
model: claude-haiku-4-5
mode: ask
description: Allows to generate a commit message based on current chat window. Requires the Joyride extension.
---

Take the whole content of this chat and format a commit message according to `fc-commit-message` skill.

Use the `fc-human-interaction` skill to ask any necessary clarifying questions to the user.

Produce the commit message as markdown

Use `fc-copy-clipboard` skill to copy the commit message to clipboard, as well as typing it out in the chat.
