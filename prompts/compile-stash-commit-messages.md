---
model: chatgpt-4
mode: ask
description: gpt generate a commit message based on stash commit messages.
---
Generate one consolidated commit message summarized and cleaned from all the stash commit messages below. The resulting message can be copied in clipboard as markdown.
# Commit Message Guidelines

Generate a markdown commit message using the following structure and formatting, including emojis and scopes.
Do **NOT** enclose the commit message in code blocks.
Use `git diff` output to understand the changes made.

## 1. Title (First Line)

- Write a concise summary (50-72 characters max).
- Use imperative mood and present tense (e.g., "Add patient CRUD endpoints").
- Add a scope in parentheses after the emoji and before the title (e.g., ✨(patient): Add patient CRUD endpoints).
- Capitalize the first letter.
- Add a blank line after the title.

## 2. Summary Paragraph

- Write a 1-2 sentence summary of all relevant changes (100-200 characters).
- Focus on what and why, not how.
- Use present tense.
- Add a blank line after the summary.

## 3. Detailed Description

- Use section headers for major features/areas, each with a relevant emoji (e.g., ✨ for features, 🔧 for refactoring, 🖥️
  for UI, 🐛 for bug fixes, etc.).
- Under each section, use bullet points for detailed changes.
- Group related changes together. Mention file names or layers when appropriate.
- Explain the "why" behind significant changes.
- Reference issue numbers with #123 if applicable.
- Make the message clear, concise, and easy to understand.
- Adjust the length of the description to fit the changes made.
- Limit lines in the body to 72-80 characters for readability.
- Never use "WIP", "temp", or similar placeholders in commit messages.
- Clearly mark breaking changes with a section (e.g., ## 💥 Breaking Changes) and describe the impact.
- Reference related documentation, specs, or design docs if relevant.
- Optionally, include a checklist section for reviewers if the commit introduces new patterns, migrations, or requires
  special attention.

## 4. Formatting Example

Follow the formatting, emoji usage, and scope tagging shown in the example below:
```markdown
✨🔧(patient): Patient Management Service Refactor (Domain Layer)

Refactor patient management logic in the domain and application layers for improved testability and maintainability.
Update related tests and documentation.

## 1. ✨ Patient Management Feature (Phase 1)

- Implement patient CRUD operations in domain/application layers
- Refactor PatientService using dependency injection (custom DI container)
- Update patient model and validation logic

## 2. 🔧 Packages/Layers Affected

- Migrate all core services and commands to dependency injection using custom DI container.

## 3. 🛠️ Github workflow

- Implement CI/CD pipeline for automated testing and deployment
- Configure linting and formatting checks
- Set up issue templates and pull request templates

## 4. 🖥️ UI

- Update patient form to use new validation logic

## 5. 🔧 Drag and Drop Refactoring

- Refactor drag-and-drop logic to use new service structure

## 6. 🛡️ Refactoring

- Refactor data access layer to use repository pattern

## 7. 🐛 Bug Fixes & Technical Debt Reduction

- Fix patient data serialization issue

## 8. 📊 Metrics & Results

- Add logging for patient operations

## 9. 🚀 Benefits

- Improve code maintainability and testability

## 10. 📄 Documentation

- Update patient management section in docs/ai/2025-09-14-PATIENT_MANAGEMENT.md

## 11. 🛡️ Compliance

- Ensure patient data encryption (HIPAA compliance)

## 12. 💥 Breaking Changes

- Remove deprecated patient endpoints; update API consumers

## 13. 🧪 Tests

- Add unit tests for PatientService
- Update integration tests for patient endpoints

## 14. 📚 Related Docs

- See design spec in docs/specs/patient-management.md

## 15. ✅ Reviewer Checklist

- [ ] Migration steps documented
- [ ] New patterns reviewed
```

Do not include any explanations or additional text.
