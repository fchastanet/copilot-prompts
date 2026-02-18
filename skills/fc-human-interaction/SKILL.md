---
name: fc-human-interaction
description: 'Interactive requirement clarification system that asks one question at a time using ask_questions to refine prompts and avoid assumptions. Use when creating task specifications, gathering requirements for complex projects, validating architectural decisions, or when user intent is ambiguous. Iteratively asks numbered questions (1/5, 2/5...), waits for answers, shows prompt updates, and continues until user types "stop". Creates final documentation in doc/ai/{date}-{title}.md. Keywords: clarify requirements, prompt refinement, decision-making, scope validation, iterative dialogue, requirement gathering, task specification.'
---

# Human Interaction: Requirement Clarification Protocol

**Prevent assumptions through structured one-by-one questioning that refines prompts and gathers user decisions before implementation.**

## When to Use This Skill

**Trigger phrases and scenarios:**

✅ **USE when user says:**

- "Create a prompt for..."
- "I need to clarify requirements"
- "What approach should we take?"
- "Help me refine this task"
- "Multiple options exist"
- "I'm not sure about..."
- "Gather requirements for..."
- "Build a POC for..." (without detailed specs)

✅ **USE in these situations:**

- Creating prompts or task specifications
- Gathering requirements for complex projects
- Multiple architectural/technical approaches exist
- Assumptions need validation before implementation
- User intent is unclear or ambiguous
- Configuration or customization decisions needed
- Technology stack selection required

❌ **DON'T USE when:**

- User provides explicit, complete requirements
- Task is straightforward with no ambiguity
- User says "just implement it as you see fit"
- Simple code snippets or examples requested
- Only reading files or performing searches
- Emergency fixes or time-sensitive tasks

## Prerequisites

- `ask_questions` tool must be available
- User availability for 5-15 minutes of interaction
- Clear understanding of the base task/goal
- User willingness to make decisions

## Step-by-Step Workflow

### Step 1: Initialize Clarification Phase

Announce skill usage and set expectations.

### Step 2: Ask First Question (Format: X/Y)

Use `ask_questions` with format: **Question N/Total: [Category]**

**Priority order:** Foundational (architecture, tech stack) → Functional
(features, scope) → Technical (errors, security, performance) → Operational
(deployment, testing)

### Step 3: Wait for Response

Retry up to 3 times on timeout. After 3 attempts, document assumption and proceed.

### Step 4: Show Prompt Update Based on Answer

Display what changed with BEFORE/AFTER format. Always show diff before proceeding to next question.

### Step 5: Ask Next Question (Build on Previous Answer)

Ask follow-up questions dependent on previous answers.
Repeat Steps 2-5 until user types "stop" or critical questions answered (3-7 typical).

### Step 6: Handle "stop" Signal

When user types "stop", finalize clarification with decision summary and proceed to documentation.

### Step 7: Create Final Documentation

**Action:** Generate "doc/ai/{YYYY-mm-dd}-{shortTitle}.md" using this template:
`references/documentation.template.md`

## Question Design Best Practices

- Be specific with context and trade-offs
- Provide 2-4 options per question
- Build follow-ups on previous answers

## Critical Requirements

- Ask one question at a time
- Always use `ask_questions` for user input
- Show diff after each answer
- Respect "stop" signal immediately
- Always create "doc/ai/{date}-{title}.md"
