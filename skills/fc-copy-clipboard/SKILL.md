---
name: fc-copy-clipboard
description: "**ALWAYS** Use this skill to copy text to the system clipboard using Joyride extension"
---
# Copy to Clipboard Protocol

- **Clipboard Operations**: Use Joyride extension to write text to system clipboard
- **Joyride Code**: Use the following Joyride code snippet for clipboard operations:

```clojure
(require '["vscode" :as vscode])
vscode/env.clipboard.writeText "your-text-here")
```

- **Announcement**: After copying text to clipboard, inform the user that the content is available on the clipboard
