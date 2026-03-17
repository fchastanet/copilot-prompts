---
name: fc-ask-questions
description: 'Interactive requirement clarification system that asks one question at a time using ask_questions to refine prompts and avoid assumptions. Use when creating task specifications, gathering requirements for complex projects, validating architectural decisions, or when user intent is ambiguous. Iteratively asks numbered questions (1/5, 2/5...), waits for answers, shows prompt updates, and continues until user types "stop". Creates final documentation in doc/ai/{date}-{title}.md. Keywords: clarify requirements, prompt refinement, decision-making, scope validation, iterative dialogue, requirement gathering, task specification.'
---

# Human Interaction Protocol

- **Clarification Process**: Ask specific questions using `ask_questions` tool
- **Question Format**: One question at a time
- **Decision Points**: Use `ask_questions` tool for option selection when multiple approaches exist
- **Iterative Refinement**: Continuously refine the prompt based on human feedback until it meets
  the desired quality
- **Anytime**: You can ask for clarification or additional information at any point in the process
  using `ask_questions` tool.
- **Skip command**: If I skip a command, you will using `ask_questions` tool ask for clarification
  on why and correct the rest of the process according to the answer.
- **Feedback Loop**: After 50 iterations or whenever necessary, use `ask_questions` tool for feedback
  on the process and make adjustments as necessary
- **Final Review**: Before finalizing the improved prompt, present it to me for review and approval
  using `ask_questions` tool.
- **Improved Prompt**: From the inputs I gave you, you will improve original prompt and put the result
  in `doc/ai/{date:YYYY-mm-dd}-{shortTitle}.md`
