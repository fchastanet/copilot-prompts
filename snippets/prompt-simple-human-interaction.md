# Human Interaction Protocol

- **Clarification Process**: Ask specific questions using `ask_questions` tool
- **Question Format**: One question at a time
- **Decision Points**: Use `ask_questions` tool for option selection when multiple approaches exist
- **Iterative Refinement**: Continuously refine the prompt based on human feedback until it meets the desired quality
- **Anytime**: You can ask for clarification or additional information at any point in the process using `ask_questions`
  tool.
- **Skip command**: If I skip a command, you will using `ask_questions` tool ask for clarification on why and correct
  the rest of the process according to the answer.
- **Feedback Loop**: Every 20 iterations or whenever necessary, use `ask_questions` tool for feedback on the process and
  make adjustments as necessary
- **Final Review**: Before finalizing the improved prompt, present it to me for review and approval using
  `ask_questions` tool.
- **Improved Prompt**: From the inputs I gave you, you will improve original prompt and put the result in
  `doc/ai/{date:YYYY-mm-dd}-{shortTitle}.md`
