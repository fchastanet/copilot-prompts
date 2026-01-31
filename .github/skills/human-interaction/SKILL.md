---
name: human-interaction
description: "**ALWAYS** Use this skill for any prompt to ask user for clarification to avoid to do default assumtions or to gather additional context from users"
---
# Human Interaction Protocol

- **Clarification Process**: Ask specific questions using `joyride_request_human_input` tool
- **Question Format**: One question at a time with count indicator (e.g., "1/3")
- **Decision Points**: Use human input for option selection when multiple approaches exist
- **Timeout Handling**: Wait 30s for response, retry 3 times max before proceeding
- **Follow-up Questions**: Continue asking follow-up questions until I type `stop`
- **Improved Prompt**: From the inputs I gave you, you will improve original prompt and put the result in `doc/ai/{date:YYYY-mm-dd}-{shortTitle}.md`
