---
name: fc-ai-generate
description: >
  Analyse a repository and scaffold minimal AGENTS.md files (root + sub-directories),
  llms.txt files and reusable SKILL.md files.
  Use when bootstrapping AI-agent navigation for a new or existing repository.
  Delegates to
  - fc-ai-generate-agents-md (for AGENTS.md generation)
  - fc-ai-generate-skills-md (for reusable skills)
  - fc-ai-generate-llms (for llms.txt generation)
  - fc-ai-generate-pre-commit-config (for pre-commit configuration)
argument-hint: "Optionally specify a subdirectory to scope the analysis"
---

# fc-ai-generate

You are a GitHub Copilot setup specialist. Your task is to create or update a complete, production-ready GitHub Copilot configuration for a project based on the specified technology stack.

Scaffold AI-agent guidance for a repository:

- a minimal root `AGENTS.md`
- targeted sub-directory `AGENTS.md` files
- reusable `SKILL.md` files
- a comprehensive `llms.txt` file

## Core principle

> AGENTS.md should contain what AI **cannot deduce from the code**.
> Keep it small. Point elsewhere. Let progressive disclosure do the rest.

## 🚀 Phased Execution Strategy

**This skill uses automatic checkpointing with session memory** to handle the heavy analysis workload without timeouts.

### Execution Workflow

The analysis is broken into **4 sequential phases** (3-5 minutes each). Each phase:

- Required: Checks for previous phase data in session memory
- Required: Processes its specific scope
- Required: 💾 Saves results to `/memories/session/fc-ai-generate-analysis-phase{N}.json` (where N is the current phase number 1–4)
- Required: 📝 Shows a summary of findings
- Required: ➡️ Indicates next phase to run

**How to use:**

1. Run: `@workspace /fc-ai-generate` (or with `phase=1`)
2. Review phase summary
3. Continue: `@workspace /fc-ai-generate phase=2`
4. Repeat until Phase 6 generates the final report

**Recovery:** If interrupted, just restart from the last completed phase. All previous work is preserved in session memory.

### Workflow

For each sub-agent, pass the target files in the context of the sub-agent.

**Phase-to-sub-skill mapping:** Phase 1 = fc-ai-generate-agents-md, Phase 2 = fc-ai-generate-skills-md, Phase 3 = fc-ai-generate-llms, Phase 4 = fc-ai-generate-pre-commit-config, Phase 5 = fc-ai-generate-matrix. Run the Analysis checklist once during Phase 1, before invoking any sub-skill.

Run these six phases **in order**:

1. Analysis checklist
   Analyse the workspace to collect facts about the repository structure, tech stacks, test frameworks, code conventions, build pipeline, sub-projects, and sensitive areas. This analysis will inform all subsequent phases.
   Ignore all the files listed in `.gitignore`.
   If the repository is very large or complex, use sub agents to parallelize the analysis of different areas or types of files.
   💾 Saves results to `/memories/session/fc-ai-generate-analysis-phase1.json`

2. **[fc-ai-generate-agents-md](/.github/skills/fc-ai-generate-agents-md/SKILL.md)**
   Analyse the workspace and produce root + sub-directory `AGENTS.md` files.
   When generating AGENTS.md files, leave skill references as placeholder bullets
   (e.g. `- <skill-TBD>`) to be filled in after step 2 completes.
   💾 Saves results to `/memories/session/fc-ai-generate-analysis-phase2.json`

3. **[fc-ai-generate-skills-md](/.github/skills/fc-ai-generate-skills-md/SKILL.md)**
   Identify reusable patterns and produce lightweight `SKILL.md` files that the
   generated `AGENTS.md` files can reference. Update the placeholder bullets from
   step 1 with the actual skill paths.
   💾 Saves results to `/memories/session/fc-ai-generate-analysis-phase3.json`

4. **[fc-ai-generate-llms](/.github/skills/fc-ai-generate-llms/SKILL.md)**
   Create a comprehensive `llms.txt` file that serves as an entry point for LLMs
   to understand and navigate the repository effectively.
   💾 Saves results to `/memories/session/fc-ai-generate-analysis-phase4.json`

5. **[fc-ai-generate-pre-commit-config](/.github/skills/fc-ai-generate-pre-commit-config/SKILL.md)**
   Generate a root `.pre-commit-config.yaml` file to check for common issues and enforce code quality.
   💾 Saves results to `/memories/session/fc-ai-generate-analysis-phase5.json`

6. **[fc-ai-generate-matrix](/.github/skills/fc-ai-generate-matrix/SKILL.md)**
   Analyse the repository and scaffold a detailed maintenance matrix in `.github/skills/maintenance-matrix/SKILL.md`, mapping recurring maintenance tasks to specific files, directories, or patterns.
   💾 Saves results to `/memories/session/fc-ai-generate-analysis-phase6.json`

If a sub-skill file cannot be loaded, inform the user in chat: `Sub-skill {name} could not be loaded — verify the file path and try again.`

### Analysis checklist (run before any sub-skill)

Collect the following facts once; all sub-skills reuse them.

**Start with config files** to get a map of declared dependencies:

- Tech stacks: `composer.json`, `package.json`, `Makefile`, `build.xml`, `Jenkinsfile`, ...
- Test frameworks: `phpunit.xml*`, `jest.config*`, `vitest.config*`, `cypress.config*`, ...
- Code conventions: `.phpcs.xml`, `.eslintrc*`, `phpstan*.neon`, `.stylelintrc*`, ...
- Build pipeline: `.github/workflows/`, `Jenkinsfile`, `build.xml`, `gulpfile*`, `webpack.config*`, ...
- Sub-projects: directories with their own `composer.json`, `package.json`, ...
- Sensitive areas: Auth, cryptography, payment, PII handling, ...

**Then read actual source files** — config files only show declared dependencies; source
files reveal how the code is actually structured. Look for:

- Template engines actually used in files (`.hbs`, `.twig`, `.pug`, `.ejs`, `.blade.php`, …)
- JS frameworks/patterns in `.js` files beyond what `package.json` declares
  (e.g. a repo with Vue *and* Backbone, or a custom Flux/event system)
- libraries usage patterns
- Custom patterns that differ sub-directory to sub-directory within the same package
- State management approaches that are project-specific (custom stores, global objects)
- Mixed paradigms in the same repo (e.g. legacy jQuery alongside modern framework code)
- Technology usage (Aws SDK, Big Query, ...) that warrants specific review rules

> The predefined lists in the sub-skills are **starting points, not exhaustive checklists**.
> If source files reveal a pattern not on any list, create the appropriate skill/AGENTS.md anyway.

### What NOT to generate

- **CRITICAL:** Do **not** duplicate content already readable from code (class names, function signatures).
- **CRITICAL:** Do **not** create an AGENTS.md larger than 60 lines.
- **CRITICAL:** Do **not** create a SKILL.md larger than 80 lines.
- **CRITICAL:** Do **not** fill in the '⚠ Questions for reviewer' sections in generated AGENTS.md — leave every question unanswered for a human reviewer.

## Ask questions

Whenever you encounter something in the code that you cannot confidently interpret, use `askQuestions` tool to ask the user for clarification.
Do not make assumptions about the code that you cannot verify.
