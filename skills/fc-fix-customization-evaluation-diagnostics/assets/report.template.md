# Diagnostic Report

## 1. Overall summary

| Issue Type                 | Count Found     | Count Fixed     | Count Not Fixed   |
| -------------------------- | --------------- | --------------- | ----------------- |
| Contradictions             | A               | B               | C                 |
| Ambiguities                | D               | E               | F                 |
| Persona Inconsistencies    | G               | H               | I                 |
| Cognitive Load Issues      | J               | K               | L                 |
| Semantic Coverage Gaps     | M               | N               | O                 |
| Verbosity Issues           | P               | Q               | R                 |
| Composition Conflicts      | S               | T               | U                 |
| -------------------------- | --------------- | --------------- | ----------------- |
| Total                      | A+D+G+J+M+P+S   | B+E+H+K+N+Q+T   | C+F+I+L+O+R+U     |

- Overall Cognitive Load complexity: {low|medium|high|very-high}.
- Overall Semantic coverage: {comprehensive|adequate|limited|minimal}.
- Overall Verbosity: {concise|moderately verbose|verbose|excessively verbose}.

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

## 7. Verbosity

_Unnecessarily wordy or complex language that could be simplified._

**Issue V#1**

- **Severity**: warning | info
- **File reference**: `{filename}:lineNumber` as a clickable link to the exact line in the file
- **Problematic text**: `{exact quoted text}`
- **Explanation**: {explanation of why this is too verbose for an AI model and how it could be simplified}
- **Suggested fix**: {how to rewrite this in a simpler way while retaining the original meaning and intent}
- **Fix applied**: **no**

## 8. Composition Conflicts

_Conflicts between this file and the prompt files it imports._

**Issue CC#1**

- **Severity**: error | warning
- **File references**: `{filename}:lineNumber` vs `{conflictingFilename}:lineNumber` as clickable links to the exact
  lines in the files
- **Problematic text**: `{exact quoted text from the first file}` vs `{exact quoted text from the conflicting file}`
- **Explanation**: {concrete explanation of WHY these conflict and what wrong behavior the model would exhibit}
- **Suggested fix**: {how to resolve the conflict}
- **Fix applied**: {yes | **no**}
