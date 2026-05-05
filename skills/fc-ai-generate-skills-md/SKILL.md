---
name: fc-ai-generate-skills-md
description: >
  Analyse a repository and generate lightweight, reusable SKILL.md files for
  recurring agent tasks (code review, test generation, documentation). Each skill
  targets a specific tech stack or directory context. Use when: bootstrapping agent
  skills for a repo, adding a new review or generation skill, making skills
  directory-aware (e.g. legacy vs modern code areas).
argument-hint: "Optionally restrict generation to one family: review, generate-test, generate-doc, or generate"
---

# fc-ai-generate-skills-md

Generate focused `SKILL.md` files for reusable agent tasks. Keep each skill
under 80 lines. Skills live in `.github/skills/<skill-name>/SKILL.md`.

## When to create a skill

Create a skill when the **same task pattern** appears in 2 or more directories with
rules that would conflict if placed in root AGENTS.md. Do NOT create a skill for a
pattern found in only one directory.

## Common skill family prefixes (non-exhaustive)

- **`review-*`**: Code review for a specific stack, framework, or pattern
- **`generate-test-*`**: Unit / integration test generation
- **`generate-doc-*`**: Documentation generation
- **`generate-*`**: Any other recurring generation task

## How to detect which skills are needed

**Do not limit detection to the examples below** — they are starting points.
The real detection method is to read source files and observe recurring patterns.

### ⚠ Config-file tunnel vision — the most common analysis failure

Technologies loaded via CDN, vendored inline, or pre-dating modern package managers will
be **invisible** to `package.json` / `composer.json` analysis. Always start from files,
not from config.

Step 0 — **Discover all source directories unconditionally, before reading any config file**:

1. Find all `.js` files repo-wide (exclude `node_modules`, `vendor`, `dist`, build outputs).
   Group by directory prefix. Any directory cluster you don't already know about is a
   candidate for a distinct tech stack.
2. Do the same for `.php`, `.ts`, `.py`, and any other code file types present.
3. For each discovered directory group, open one representative file and identify the
   framework or pattern FROM THE CODE — not from config files. Ask: "What does this file
   say about how this directory is structured?"

**Framework fingerprints to look for in JS files:**

- `Ext.define(...)` / `Ext.require(...)` / `Ext.Loader` → **ExtJS** (loaded via CDN — will not appear in `package.json`)
- `define([...], function(...))` → AMD / RequireJS
- `angular.module(...)` → AngularJS
- `React.createElement` / JSX / `import React` → React
- `Backbone.Model.extend(...)` → Backbone.js
- `App.X = something.extend(...)` on a global namespace → custom Backbone-like pattern
- `window.X = ...` / single global object → vanilla or custom framework

**PHP file fingerprints:**

- `namespace Foo\Bar;` + `use ...;` → autoloaded, namespaced
- `class Foo {` with no namespace → global class, manually included
- `require_once $GLOBALS[...]` or `include_once(...)` → flat include pattern (no autoloader)
- Raw `mysql_query(...)` / `PDO::exec(...)` with string concat → direct SQL, legacy

Step 1 — scan config files for declared dependencies (supplements, does not replace, Step 0):

- `composer.json` with Symfony → likely needs `review-php`
- `phpunit.xml*` → likely needs `generate-test-phpunit`
- `package.json` with Vue → likely needs `review-vue`
- `package.json` with Jest → likely needs `generate-test-jest`

Step 2 — **cross-check** Step 0 findings against Step 1: anything found in Step 0 that is
absent from config files is a strong signal of a vendored/CDN dependency needing its own skill.
Then read more files in those directories:

- Look at template files: `.hbs`, `.twig`, `.pug`, `.ejs`, `.blade.php`, `.jinja`
- Look for custom patterns: proprietary state management, global objects, internal libraries
- Look at SQL usage: raw queries vs ORM vs query builder each needs different review rules
- Look at test file structure: naming conventions, base classes, mock strategies

Step 3 — infer skills from what you found, **not limited to this list**.
If source files reveal a recurring pattern that needs tailored rules, create the skill.
Name it descriptively (e.g. `review-backbone-handlebars`, `review-twig`,
`generate-test-cypress`). Do not skip a skill just because it is not listed here.

[Skill template](assets/skill.template.md)

## Directory-aware rules

Some skills need different rules for legacy vs modern areas. Add a
`### Directory-specific overrides` subsection rather than creating separate
skill files for each sub-directory. Example:

```markdown
## Directory-specific overrides

### `classes/CrossKnowledge/` and `source/` (legacy)
- PSR-0 namespaces are acceptable; do not refactor to PSR-4.
- Direct SQL queries are allowed; flag un-parameterised inputs as security issues.
- Do not add type declarations to existing legacy functions.

### `src/` (modern Symfony)
- Enforce strict types (`declare(strict_types=1)`).
- Services must be injected via constructor DI, not `$this->get(...)`.
```

## Skill registration

After creating a skill file, register it in the AGENTS.md that covers all directories
where it applies: use root AGENTS.md for repo-wide skills, and the nearest common
ancestor sub-directory AGENTS.md for skills that apply to a subset of directories.
If the target AGENTS.md does not yet exist, note the registration as a TODO comment
at the end of the generated SKILL.md.

If a SKILL.md already exists at the target path, diff the proposed content and ask
the user to confirm before overwriting.

If no recurring patterns are detected, do not generate any skill files. Notify the
user with a summary of what was scanned and why no skills were warranted.

```markdown
## Skills
- `.github/skills/review-php/SKILL.md` — PHP code review
- `.github/skills/review-symfony/SKILL.md` — Symfony-specific review
```

## Anti-patterns to avoid

- Do not generate markdown tables - Use bullet points and sections instead.
- Do not duplicate rules already in an `AGENTS.md` file.
- Do not add rules enforced by linters/CI already in the repo.
- Do not inline full style guides — link to them.
- Do not exceed 80 lines per skill.
- Do not create a skill whose rules apply everywhere identically — put those in root `AGENTS.md`.
- **CRITICAL:** Do **not** add instructions AI already knows or can infer.
  it is not a human-readable README — it is guidance for an AI that can read the code.

## Ask questions

Whenever you encounter something in the code that you cannot confidently interpret, use `askQuestions` tool to ask the user for clarification.
Do not make assumptions about the code that you cannot verify.
