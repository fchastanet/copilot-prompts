# Diagnostic Report

## 1. Overall summary

- Issues: {X issues found across Y categories.}
  - Contradictions: {A found, B fixed}.
  - Ambiguities: {C found, D fixed}.
  - Persona inconsistencies: {E found, F fixed}.
  - Cognitive load issues: {G found, H fixed}.
  - Semantic coverage gaps: {I found, J fixed}.
- Overall Cognitive Load complexity: {low|medium|high|very-high}.
- Overall Semantic coverage: {comprehensive|adequate|limited|minimal}.
- Overall fixes applied: {Z out of X}.

## 2. Contradictions

_Instructions that directly conflict with each other — the model would exhibit inconsistent or wrong behavior._

**Issue C#1**

- **Severity**: error | warning
- **File references**: `{filename}:lineNumber` vs `{filename}:lineNumber` as clickable links to the exact lines in the
  file
- **Problematic text**: `{exact quoted text from the file}`
- **Explanation**: {explanation of why this specific text conflicts, in the context of the full file}
- **Suggested fix**: {concrete rewrite or replacement text}
- **Fix applied**: {yes | **no**}

...

## 3. Ambiguity

_Vague or underspecified instructions a model could interpret in multiple ways._

**Issue A#1**

- **Severity**: warning | info
- **File reference**: `{filename}:lineNumber` as a clickable link to the exact line in the file
- **Problematic text**: `{exact quoted text}`
- **Explanation**: {the multiple interpretations a model could take}
- **Suggested fix**: {concrete rewrite}
- **Fix applied**: {yes | **no**}

## 4. Persona Consistency

_Places where tone, personality, or role contradicts itself._

**Issue P#1**

- **Severity**: warning | info
- **File reference**: `{filename}:lineNumber` as a clickable link to the exact line in the file
- **Description**: {what exactly is inconsistent about the persona}
- **Trait 1**: {first trait or tone}
- **Trait 2**: {conflicting trait or tone}
- **Explanation**: {explanation of why these traits or tones are inconsistent and what wrong behavior the model would
  exhibit}
- **Relevant text**: `{exact text from the prompt where this is most evident}`
- **Suggested fix**: {how to make the persona consistent — pick one approach or reconcile them}
- **Fix applied**: {yes | **no**}

## 5. Cognitive Load

_Overly complex patterns that are hard for a model to follow correctly._

**Issue CL#1**

- **Severity**: warning | info
- **File reference**: `{filename}:lineNumber` as a clickable link to the exact line in the file
- **Type**: nested-conditions | priority-conflict | deep-decision-tree | constraint-overload
- **Problematic text**: `{exact quoted text}`
- **Deep decision**: If the issue is a deep decision tree, include a bullet list of the branches and conditions that
  make it complex.
- **Explanation**: {explanation of what makes this hard for a model to follow and what mistakes it would likely make}
- **Suggested fix**: {how to restructure this — e.g. break into numbered steps, use a table, split into separate
  prompts}
- **Fix applied**: {yes | **no**}

## 6. Semantic Coverage

_Scenarios or edge cases the prompt does not address._

**Issue SC#1**

- **Severity**: warning | info
- **File reference**: `{filename}:lineNumber` as a clickable link to the exact line in the file
- **Missing scenario**: {description of the scenario or edge case that is not covered by the prompt}
- **Explanation**: {explanation of why this scenario is important to cover and what could go wrong if it is not}
- **Suggested fix**: {how to modify the prompt to cover this scenario}
- **Fix applied**: {yes | **no**}

## 7. Composition Conflicts

_Conflicts between this file and the prompt files it imports._

**Issue CC#1**

- **Severity**: error | warning
- **File references**: `{filename}:lineNumber` vs `{conflictingFilename}:lineNumber` as clickable links to the exact
  lines in the files
- **Problematic text**: `{exact quoted text from the first file}` vs `{exact quoted text from the conflicting file}`
- **Explanation**: {concrete explanation of WHY these conflict and what wrong behavior the model would exhibit}
- **Suggested fix**: {how to resolve the conflict}
- **Fix applied**: {yes | **no**}
