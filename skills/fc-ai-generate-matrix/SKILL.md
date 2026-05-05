---
name: fc-ai-generate-matrix
description: >
  Analyse a repository and scaffold a detailed maintenance matrix in .github/skills/review-maintenance-matrix/SKILL.md, mapping recurring maintenance tasks to specific files, directories, or patterns. Use when: bootstrapping maintenance guidance for a repo, adding new maintenance tasks, refreshing stale maintenance documentation.
---

# fc-ai-generate-matrix

You are a GitHub Copilot setup specialist. Your task is to create or update a complete `.github/skills/review-maintenance-matrix/SKILL.md`.

## Core principle

A maintenance matrix covers:

- What files reference each other (e.g., a game registry that must be updated when a new scene is added)
- What must be updated when different parts of the codebase change
- Cross-cutting concerns (e.g., version numbers in multiple files, route registrations, module re-exports)
- Recurring maintenance tasks and their associated files (e.g., "update README and changelog when a new feature is added")
- Any non-obvious maintenance requirements (e.g., "when updating the database schema, also update the corresponding SQL migration files and the schema documentation")
- Any known maintenance pitfalls or gotchas (e.g., "be careful when updating the authentication logic, as it is tightly coupled with the session management code")
- Any specific instructions for maintaining different parts of the codebase (e.g., "when adding a new API endpoint, remember to update the API documentation and add tests in the `tests/api` directory")

## Update code review skill

if a code review skill already exists, add a section referencing the maintenance matrix and instructing reviewers to check it for relevant maintenance tasks when reviewing PRs. If no code review skill exists, create one and include this reference.

## Open questions for reviewer

If one of the Core principle points cannot be fully answered by analyzing the repository, add a question to this section for the reviewer to answer.

- [ ] Q: Are there any specific maintenance tasks or requirements that are unique to this codebase and should be included in the matrix?
- [ ] Q: Are there any known maintenance pitfalls or gotchas that should be highlighted in the matrix?
- [ ] Q: Are there any specific instructions for maintaining different parts of the codebase that should be included in the matrix?
- [ ] Q: Should the maintenance matrix include a section on how to keep it up to date, such as a reminder to update it whenever new maintenance tasks are identified or when changes are made to the codebase that affect existing maintenance tasks?
