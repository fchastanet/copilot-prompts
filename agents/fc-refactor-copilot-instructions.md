---
mode: agent
description: Refactor the attached AI file(Eg: .github/copilot-instructions.md) to remove duplicated parts and make it AI compatible
---

Several parts are duplicated and sometimes not accurate in attached files. This file is not intended to be read by a
human:

- remove duplicated parts
- reorganize the file to make it ai compatible.
- Remove the parts that are obvious for an AI.

# Human Interaction Protocol

- **Clarification Process**: Ask specific questions using `ask_questions` tool
- **Question Format**: One question at a time with count indicator (e.g., "1/3")
- **Decision Points**: Use human input for option selection when multiple approaches exist
- **Follow-up Questions**: Continue asking follow-up questions until I type `stop`
