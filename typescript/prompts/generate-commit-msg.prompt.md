---
mode: ask
model: GPT-41
description: "Allows to generate a commit message based on current chat window. Requires the Joyride extension."
---
Take the whole content of this chat and format a commit message according to .github/instructions/commit-message.instructions.md.

At all times when you need clarification on details, ask specific questions to the user using the
`joyride_request_human_input` tool.

Produce the commit message as markdown, use Joyride to place the markdown on the system clipboard, as well as typing it
out in the chat. Use this Joyride code for clipboard operations:

```clojure
(require '["vscode" :as vscode])
(vscode/env.clipboard.writeText "your-markdown-text-here")
```
