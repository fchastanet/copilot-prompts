---
name: fc-ai-generate-agents-md
description: >
  Analyse a repository and generate minimal, focused AGENTS.md files at the root
  and in relevant sub-directories. Each file gives AI agents just enough context
  to work effectively, with pointers to detailed guidance rather than inlining it.
  Use when: bootstrapping AGENTS.md for a repo, adding sub-directory AGENTS.md,
  refreshing stale agent guidance.
argument-hint: "Optionally specify a subdirectory to limit scope"
---

# fc-ai-generate-agents-md

Generate minimal `AGENTS.md` files. One root file, plus sub-directory files only
where the tech stack, conventions, or risk profile differs (see conditions below).

Analyse the whole repository and detect where sub-directory AGENTS.md files are needed
based on tech stack, conventions, or risk profile differences (see rules below).
If a subdirectory argument is provided, limit analysis to that subtree; inform the user in chat that
detection may be incomplete without full-repo context.
Do not generate more than 15 AGENTS.md files per repository.
If analysis identifies more than 15 candidate locations, use `askQuestions` tool to present the list and ask which to keep.

## Root AGENTS.md — required sections

- Keep it under 60 lines by moving important details to either sub-directory AGENTS.md files
  or external skills.
- Include only the sections specified in that [AGENTS.md — template](assets/AGENTS.example.md)
  (omit any section whose content would be empty or would only restate information deducible from the directory structure or config files).
- If the template file is missing, apply the section rules described in this skill rather than aborting.

## When to create a sub-directory AGENTS.md

Create one **only** when at least one condition is true:

- Different tech stack (e.g. `frontend/` uses JS/Vue while root is PHP)
- Different framework or templating engine within a shared `package.json` scope
  (e.g. a sub-directory uses Backbone+Handlebars while the rest uses Vue)
- A sub-directory of a "legacy" area uses a different language or framework than its siblings
  (e.g. `source/js/` inside a flat-PHP `source/` is an ExtJS app — a completely different tech)
- Different Symfony bundles
- Different library or technology that requires specific review rules (e.g. AWS SDK, Big Query, ...)
- Different test framework or test runner
- Legacy code with different conventions (no namespaces, direct SQL, PSR-0)
- Legacy sub-directories with meaningfully different loading or class patterns
  (e.g. `source/includes/` library classes loaded via `require_once` vs `source/*.php` flat pages)
- Significantly different risk profile (auth, payment, PII)
- The directory has its own `composer.json` or `package.json`
- Architecture changes (e.g. microservice vs monolith, or different subdomains)
- **Any other factor discovered by reading source files** that would cause an AI to apply
  different rules than in the parent — trust your analysis, not just this list

⚠ **Do not infer directory contents from the parent or from config files alone.**
Open a file in each non-trivial sub-directory and read it. A `source/` that looks like
"legacy flat PHP" at the top level may contain:

- `source/js/` — a full ExtJS app (loaded via CDN, invisible to `package.json`)
- `source/includes/` — library-style PHP classes loaded via `require_once`
- `source/templates/` — server-side templates with their own conventions

Each of these deserves its own AGENTS.md if an AI editing a file there would otherwise
apply the wrong rules from the parent.

Place it at the directory root. Omit anything already covered by the parent —
child AGENTS.md **merges** with the nearest ancestor; closest wins on conflicts.

[Sub-directory AGENTS.md — template](assets/AGENTS.subDirectory.example.md)

## Glossary & questions — guidance

**Glossary**: add entries for abbreviations, domain terms, or naming patterns
that appear in the code but whose meaning is not self-evident (e.g. acronyms,
internal product names, table-column mappings to domain concepts).

**Questions**: use `askQuestions` tool for ambiguities that would block correct
generation (e.g. which directories are legacy). Embed a `⚠ Questions for reviewer`
section in the AGENTS.md for facts that are knowingly undeducible from code alone.
Examples (but do not limit yourself to these):

- Deployment process
- Which directories are considered "legacy" vs "maintained"
- Rollback strategy
- External service credentials management
- Ownership / on-call team

## AGENTS.md inheritance rules (from agents.md spec)

- An agent reads all AGENTS.md files from the repo root down to the edited file.
- Child content **merges** with parent content.
- When a rule in a child **contradicts** a parent rule, the child wins.
- Explicit user prompts override everything.

## Anti-patterns to avoid

- Do not generate markdown tables - Use bullet points and sections instead.
- Do not inline full documentation — link to it.
- Do not list every file or class — AI is expected to understand structure at the directory level.
- Do not add rules already enforced by linters or CI.
- **CRITICAL:** Do **not** add instructions AI already knows or can infer.
  it is not a human-readable README — it is guidance for an AI that can read the code.

## Never include in AGENTS.md

Absolutely forbidden:

- API keys, tokens, passwords, or any credentials
- Database connection strings with passwords
- AWS access keys or secret keys
- Private encryption keys or certificates
- OAuth secrets or JWT signing keys
- Production IP addresses or internal URLs
- Customer data or personally identifiable information
- Proprietary algorithms or trade secrets
- Security vulnerability details
- Detailed firewall or security group configurations

## Ask questions

Whenever you encounter something in the code that you cannot confidently interpret, use `askQuestions` tool to ask the user for clarification.
Do not make assumptions about the code that you cannot verify.
