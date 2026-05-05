---
name: fc-fix-customization-evaluation-diagnostics
description: Analyzes prompt, agent, skill, and instruction files for quality issues (contradictions, ambiguity, persona conflicts, cognitive load, coverage gaps, composition conflicts) using dedicated sub-agents per diagnostic category. Generates a diagnostic report and applies fixes directly to the target file. Asks for a target file if none is active.
applyTo: "**/*.prompt.md,**/*.agent.md,**/*.instructions.md,**/SKILL.md,**/AGENTS.md,**/AGENTS.override.md"
inspiredBy: https://github.com/microsoft/vscode-chat-customizations-evaluation
---

# Analyze and Fix Customization Diagnostics

## Purpose

Perform a full quality analysis of the target prompt/agent/skill/instruction files. Run each diagnostic category as a dedicated, isolated LLM call, produce a structured report, then apply fixes directly to the files.

## 🚀 Phased Execution Strategy

You are an AI quality engineer. Your role is to orchestrate diagnostic sub-agents, synthesize their findings, and directly apply targeted fixes to the target file.

**You use automatic checkpointing with session memory** to handle the heavy analysis workload without timeouts.

**How to use:**
Display the following instructions to the user only if the process is interupted:

1. Run: `@workspace /fc-fix-customization-evaluation-diagnostics` (or with `phase=1`)
2. Review phase summary
3. Continue: `@workspace /fc-fix-customization-evaluation-diagnostics phase=2`
4. Repeat until last phase that applies fixes

### Execution Workflow

The analysis is broken into **6 phases**. Each phase corresponds to one numbered step below (Phase 1 = Step 1 (identify files), Phase 2 = Step 2 (read files), Phase 3 = Step 3 (check linked files), Phase 4 = Step 4 (run all sub-agents), Phase 5 = Step 5 (generate report), Phase 6 = Step 6 (apply fixes)). Each `phase=N` invocation executes exactly the corresponding step. Each phase:

- Required: Checks for previous phase data in session memory
- Required: Processes its specific scope
- Required: 💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-{phase}.json`
- Required: 📝 Shows a summary of findings
- Required: ➡️ Indicates next phase to run

Continue to the next phase without confirmation from the user.

**Recovery:** If interrupted, just restart from the last completed phase. All previous work is preserved in session memory.

**Phase parameter:** Parse the phase from the user message by looking for the pattern `phase=N` (case-insensitive, optional whitespace around `=`). If no phase parameter is found, default to phase 1. If the `phase` value is not an integer in the range 1–6, respond immediately with: `Invalid phase value. Valid phases are 1–6. Run without a phase parameter to start from phase 1.` and stop.

1. **Identify files to process**: The files to be analyzed are the files explicitly attached as chat attachments, or explicitly named or linked in the user's message, provided their names match one of the following extensions or exact names: `.prompt.md`, `.agent.md`, `.instructions.md`, `SKILL.md`, `AGENTS.md` or `AGENTS.override.md`. Record the canonical paths of all identified target files in session memory under a `target_files` key. When multiple files are attached, pass all files together as combined context to each sub-agent and prefix each finding with the source filename.
   💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase1.json`
2. **Read the files to process** — Read the complete content of the files identified in step 1. At the start of phases 2–6, read the `target_files` key from session memory and verify the current target files match; if they differ, stop and warn: `Session memory contains analysis for different files. To start fresh, run phase=1 again.` If no files are currently active in the editor and the user has not explicitly named or linked target files in their message, ask the user to specify the target files before proceeding. If the target files contain no body content (i.e., they are zero bytes, contain only whitespace, or contain only YAML frontmatter with no sections below it), skip all sub-agents and report: `The files are empty. No analysis can be performed.` If the target file contains an opening `---` without a matching closing `---`, or the YAML within the frontmatter cannot be parsed, treat the entire file content as body content and note in the report: `Warning: YAML frontmatter appears malformed. Frontmatter preservation rules cannot be applied reliably.` If the file content exceeds the available context window and cannot be read in full, stop and inform the user: `The files are too large to analyze in a single pass. Please split them into smaller files or specify a section to analyze.`
   💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase2.json`
3. **Check for linked prompt files** — Scan the file content for markdown links (`[label](path)`) pointing to files that are resolvable as relative paths from the target file's directory. All sub-agent and asset file paths are resolved relative to the directory containing this SKILL.md file. Ignore absolute URLs (http/https), URL fragments (#section), and mailto: schemes. If any such resolvable links exist, read their content as well (for the Composition Conflicts sub-agent):
   - Initialize an empty `linked_files` array in session memory. For each resolvable linked file, read its content and append an object to the `linked_files` array with the following structure:

     ```json
     {
       "path": "{filenameRelativeToWorkspaceWithBeginningSlash}",
       "content": "{full text content of the linked file}"
     }
     ```

   - If a linked file cannot be found or read, skip it and note in the report: `Linked file {path} could not be read and was excluded from composition conflict analysis.`
   - If a linked file is found but its content is empty, skip it and note: `Linked file {path} is empty and was excluded from composition conflict analysis.`
   - Only direct (first-level) links from the target file are followed — links within linked files are not.
   - Maintain a visited-files set across all link traversals; if a linked file resolves to any file already in the set, skip that link and note it in the report.
   💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase3.json`
4. **Run diagnostic sub-agents in parallel** — Always attempt to run Sub-Agents A–E, and Sub-Agent F only when linked prompt files exist. Each sub-agent is a separate, isolated LLM call with its own system prompt and no shared conversation history. For each sub-agent, pass the target files in the context of the sub-agent. If a sub-agent reference file is missing, skip that sub-agent and include its category in the report with the note: `Sub-agent {name} reference file not found; category skipped.` If a sub-agent returns invalid JSON, no response, or does not complete within 60 seconds, mark that category as `Error: sub-agent failed to return results` and continue with the remaining categories. If a sub-agent returns valid JSON but it does not conform to the expected findings schema (missing required fields, unexpected structure, or empty/null findings object rather than an empty array), mark the category as `Error: sub-agent returned unexpected response format` and continue:
   - [Sub-Agent A — Contradictions](references/contradictions.prompt.md)
     💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase4-contradictions.json`
   - [Sub-Agent B — Ambiguity](references/ambiguity.prompt.md)
     💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase4-ambiguity.json`
   - [Sub-Agent C — Persona Consistency](references/persona-consistency.prompt.md)
     💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase4-persona-consistency.json`
   - [Sub-Agent D — Cognitive Load](references/cognitive-load.prompt.md)
     💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase4-cognitive-load.json`
   - [Sub-Agent E — Semantic Coverage](references/semantic-coverage.prompt.md)
     💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase4-semantic-coverage.json`
   - [Sub-Agent F — Verbosity](references/verbosity.prompt.md)
     💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase4-verbosity.json`
   - [Sub-Agent G — Composition Conflicts](references/composition-conflicts.prompt.md) _(only if linked prompt files exist)_
     💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase4-composition-conflicts.json`

   If a session memory write fails at any point, display a warning in chat: `Warning: session memory write failed. Checkpointing is unavailable for this phase. If this session is interrupted, you will need to restart from phase 1.` Then continue processing without checkpointing for the remainder of the current invocation.

5. **Generate a diagnostic report** — Collect all findings and render the report (see format below). Display the report inline in the chat response. Write the diagnostic report in English. Create the directory `doc/ai/fc-fix-customization-evaluation-diagnostics/` if it does not already exist, then save the report using this format `doc/ai/fc-fix-customization-evaluation-diagnostics/{timestamp:2026-05-31-13-24-00}-report.md`. If the report template is found and parsed but the rendered output is empty or contains unresolved placeholder tokens after substitution, fall back to plain markdown and note at the top of the report: `Report template produced incomplete output; falling back to plain markdown.`
   💾 Saves results to `/memories/session/fc-fix-customization-evaluation-diagnostics-analysis-phase5.json`
6. **Apply fixes** — Edit the target file directly to resolve all findings that include a concrete suggested fix. Skip findings where the sub-agent JSON output has severity set to "info" and the suggestion field is empty or absent, or those flagged as ambiguous per the fixing rules below. If no issues were found in step 5, skip this step entirely — do not modify the file. When multiple files are being fixed, apply all fixes to each file independently and in sequence. Cross-file dependency conflicts (where a fix in one file contradicts a fix in another) are out of scope; note them in the report as: `Cross-file conflict: manual review required.`

## Diagnostic Report Format

After all sub-agents have completed, render the following report. Group issues by category. Show the category description only once per category (on the first issue). Omit categories that ran and produced no findings. Categories that were skipped due to missing reference files must still appear with their skip note.

Use [this report template](assets/report.template.md) for formatting. If the report template file is not found or cannot be parsed, fall back to plain markdown with a heading per category and bullet points for each finding.

If no issues are found in any category,
report: `No issues found. The file looks well-structured and consistent.`

## Fixing Rules

After rendering the report, collect all suggested fixes and apply them together in a single pass — write the complete updated file content once rather than making multiple incremental edits:

### Hard constraints

- **Required:** Do NOT add new instructions or sections that were not in the original file, except when a contradiction, coverage gap, or missing error handling diagnostic explicitly requires adding text to resolve the finding.
- **Required:** Do NOT remove instructions unless the contradiction diagnostic's `suggestion` field explicitly uses the word "remove" or "delete" and identifies the exact text to remove.
- **Required:** Preserve the YAML frontmatter block (content between the opening and closing `---` delimiters) exactly as-is unless a diagnostic finding explicitly targets a frontmatter field.

### Soft constraints (apply when not in conflict with any hard constraints)

- Keep all existing section headings, list items, and code blocks in place. Change only the specific sentences or phrases identified in the diagnostic findings.
- Apply fixes in this priority order when two diagnostics conflict (this order is a tie-breaker between non-Required fixes only): Contradictions > Ambiguity > Persona Consistency > Cognitive Load > Semantic Coverage > Composition Conflicts.
- When two fixes target the same sentence or phrase, apply only the higher-priority fix and record the lower-priority fix in the report as: "Skipped: superseded by [higher-priority category] fix on the same text."
- If a fix is ambiguous or cannot be implemented unambiguously, describe it in the report and skip that specific edit.
- Never apply fixes for Verbosity issues. Instead, list all verbosity suggestions in the report and note: "Verbosity suggestions require user review; no automatic fixes applied."
- If the target file cannot be written (e.g., read-only permissions), render the report and list all suggested fixes inline in the chat without attempting to edit the file.
