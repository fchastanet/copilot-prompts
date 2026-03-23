---
name: "fc-commit-message"
description: "Use when: writing commit messages, reviewing changes before committing, or planning changesets. Enforces message format, code quality checks, and documentation standards for commits."
---

# Commit Message & Changeset Guidelines

## Analysis

As a Senior developer, you will analyze the changes in staged files and generate a commit message that follows the guidelines below.

**CRITICAL: Analyze ONLY STAGED files, not all modified files.**

Use `git diff --cached` or `git diff --staged` to see ONLY the staged changes. **NEVER** use `git diff` alone as it shows unstaged changes.

**MANDATORY FIRST STEP: Run `git diff --cached` and list the exact files returned.**

Before writing any commit message, you MUST:
1. Execute `git diff --cached` to get the staged changes
2. List the exact filenames returned by the command
3. Verify what changes are in each file
4. Use ONLY this information - do not assume or invent any other files or changes

**Review ALL staged files without exception:**

- Use the changes tool or `git diff --cached` to get the complete list of STAGED files only
- List ALL files that are staged (added, modified, or deleted)
- For EACH staged file, examine every added, removed, and modified line
- Ensure no staged file is overlooked or ignored in your analysis
- Consider the cumulative impact of changes across all staged files
- **IGNORE any unstaged or untracked files** - they are NOT part of this commit

⚠️ **CRITICAL: NEVER invent, assume, or hallucinate files or changes.**
⚠️ **DO NOT MENTION OR DESCRIBE ANY FILE OR CHANGE THAT IS NOT PRESENT IN THE OUTPUT OF `git diff --cached`! THIS IS A HARD REQUIREMENT.**

- Only describe changes that are actually present in the staged files
- Every file mentioned in the commit message MUST appear in `git diff --cached` output
- Every change described MUST correspond to actual lines added/removed/modified in staged files
- If you cannot see a file in the staged changes, DO NOT mention it in the commit message
- Double-check that all files mentioned in your commit message are actually staged

Determine the scope based on ALL staged changes combined. Analyse deeply each staged change and determine the appropriate level of detail for the commit message (minimal, standard, or comprehensive).

⚠️ **When multiple unrelated files are staged** (e.g., infrastructure files + documentation + scripts), ensure the commit title and scope reflect the breadth of staged changes - don't focus on just one aspect.

**Identify when there are multiple staged changes** that span different areas of the codebase, and decide when to include a detailed description with section headers and bullet points.

## Required Format Structure

### Title (First Line)

⚠️ **CRITICAL: The title MUST represent ALL STAGED changes in the commit, not just one file or aspect.**

- **Summary**: If there are multiple unrelated STAGED files or areas (e.g., Dockerfile + docs + scripts), the title must either:
  - Use a generic scope that covers all staged changes (e.g., `[✨feat][project]` or `[✨feat][repo]`)
  - Mention all major aspects in the description (e.g., "Add commit guidelines, Dockerfile, and demo script")
  - **NEVER focus only on one file when multiple unrelated files are staged**
- **Length**: 120 characters maximum
- **Unique**: only the first line can be a title
- **Imperative Mood**: "add" not "adds" or "added", present tense
- **Format**: `[emoji][scope]: description`
  - Example single area: `[✨feat][auth]: Add WebSocket integration`
  - Example multiple areas: `[✨feat][project]: Add commit guidelines, Dockerfile, and demo script`
- **Capitalization**: First letter capitalized
- **Blank line**: Always add a blank line after the title

### Summary Paragraph

- **DO NOT include if**
  - The commit is straightforward and self-explanatory from the title
  - The changes are minor and do not require additional context
- **Length**: 100-200 characters (1-2 sentences)
- **Focus**: What changed and why (not how)
- **Tense**: Present tense
- **Blank line**: Always add a blank line after the summary

### Detailed Description (for commits with multiple changes)

- **DO NOT include if**
  - Summary paragraph is not needed
  - The commit only affects a single area or is straightforward
  - The commit is a simple fix or minor enhancement that does not require additional context
  - The commit does not introduce any new patterns, migrations, or complex logic that would benefit from additional explanation
- **If included**:
  - **Organization**: Use section headers with relevant emojis
  - **Sub-items**: Use bullet points under each section
  - **Grouping**: Group related changes together
  - **References**: Include file names, layers, or components when relevant
  - **Line length**: Limit body lines to 120 characters
  - **Special sections** (all optional, include as needed, always in this order):
    - `## ✨ New Features`: New features
    - `## 💥 Breaking Changes`: Document any backward-incompatible changes
    - `## 🛡️ Security`: Highlight security-related changes
    - `## 📊 Performance`: Detail performance optimizations
    - `## 🧪 Tests`: Describe new or updated tests
    - `## 📄 Documentation`: Note documentation updates
  - Explain **what** and **why**, not how
  - Blank line before footer

### Emoji Guide

Use these standard emojis to categorize change types:

| Emoji          | Meaning            | Use Case                                  |
|----------------|--------------------|-------------------------------------------|
| `[🔧refactor]` | Refactoring        | Code refactoring without behavior change  |
| `[🖥️ui]`       | UI                 | User interface changes                    |
| `[🛠️infra]`    | Infrastructure     | Build tools, CI/CD, workflows             |
| `[🛡️security]` | Security           | Security improvements or fixes            |
| `[📊perf]`     | Performance        | Performance optimizations                 |
| `[📚docs]`     | Documentation      | Documentation updates                     |
| `[🚀ci]`       | Deployment         | Release or deployment-related changes     |
| `[💥breaking]` | Breaking Change    | Breaking changes                          |
| `[🧪test]`     | Tests              | Adding or updating tests                  |
| `[🖋️style]`    | Formatting         | Code formatting changes (no logic change) |
| `[📦chore]`    | Dependencies       | Adding or updating dependencies           |
| `[⚙️config]`   | Configuration      | Changes to configuration files            |
| `[🐛fix]`      | Bug Fix            | Fixes to existing bugs                    |
| `[✨feat]`     | Feature            | New functionality or features             |

### Scope (optional)

Specify the affected component: `[auth]`, `[api]`, `[database]`, `[ui]`, etc.

### Things to Avoid

- ❌ Never use "WIP", "temp", or placeholder text
- ❌ Never include redundant or duplicate information
- ❌ Never omit the scope from the title
- ❌ Never use imperative beyond the first sentence in the summary
- ❌ Never exceed line length guidelines without good reason (and then explain why)
- ❌ **Never write a title that focuses on only one file when multiple unrelated files are staged** - the title must represent ALL staged changes or use a generic scope
- ❌ **Never analyze unstaged or untracked files** - only commit what is staged
- ❌ **Never invent, assume, or hallucinate files or changes** - every file and change mentioned MUST be present in the actual staged changes

### Footer (optional)

- Reference issues: `Fixes #123` or `Closes #456`
- Note breaking changes: `BREAKING CHANGE: description`

## Examples

Simple fix (Level 1):

```text
[✨feat][api]: handle null response in user lookup
```

More complex changes:

- (Level 2) Use [Feature with context](references/feature-with-context-commit-msg.txt) when changes apply to only one area but require additional context to understand the impact.
- (Level 2) Use [Breaking change](references/breaking-change-commit-msg.txt) when introducing backward-incompatible changes.
- (Level 3) Use [Detailed Example](references/detailed-commit-msg.txt) when changes span multiple areas or require detailed explanation. This format includes section headers, bullet points, and references to related documentation or issues.

## When Generating Commit Messages

1. **Analyze ONLY STAGED changes** using `git diff --cached` or the changes tool - list every STAGED file and review all staged changes
   - ⚠️ **CRITICAL**: Use `git diff --cached` NOT `git diff` to see only staged files
   - Verify you are analyzing ONLY what will be committed, not all modified files
   - **List the exact files returned by the command** - do NOT assume or invent any files
2. **Determine scope**: Single file, component, or multiple areas? Consider ALL staged files in your analysis
3. **Pick appropriate detail level** (minimal, standard, or comprehensive) based on the totality of staged changes
4. **Select emoji** that best represents the primary change across all staged files
5. **Define scope** (the area/component affected) - if multiple staged files span different areas, reflect that
6. **Write imperative title** that completes: "This commit will..." and accurately reflects ALL staged changes:
   - ⚠️ **If multiple unrelated files are staged** (e.g., Dockerfile + docs + scripts), the title MUST mention all major aspects or use a generic scope like `[project]` or `[repo]`
   - ❌ **BAD**: `[✨feat][docs]: Add commit message guidelines` (when Dockerfile and scripts were also staged)
   - ✅ **GOOD**: `[✨feat][project]: Add commit guidelines, Dockerfile, and demo script`
   - ⚠️ **CRITICAL**: Only mention files and changes that actually exist in the staged changes
7. **Add summary** explaining the why, covering all significant staged changes - **only describe actual staged changes**
8. **Add details** if staged changes span multiple areas, multiple files, or are complex - **only include details about actual staged changes**
9. **Remove footer** with co-authored-by
10. **Output in code block** using quadruple backticks

## Tips for Better Commit Messages

- **Only analyze staged files**: Always use `git diff --cached` to see what's actually being committed
- **Never invent changes**: Every file and change mentioned must be present in the actual staged diff output
- **Verify your sources**: Before writing the commit message, list the exact files from `git diff --cached` output
- **Be specific**: "Fix null reference in user service" is better than "Bug fix"
- **Explain context**: Why were these changes needed? What problem do they solve?
- **Use present tense**: "Add feature" not "Added feature"
- **Keep it scannable**: Use headers and bullet points for readability
- **Reference issues**: Use #123 format to link to related issues
- **Link to docs**: Reference design docs or specifications when relevant

## Check List

- [ ] I listed the exact staged files.
- [ ] I described only changes in those files.
- [ ] I did not mention any unstaged or non-existent files.
