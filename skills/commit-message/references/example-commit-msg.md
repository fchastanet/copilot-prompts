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
