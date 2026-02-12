# Copilot Instructions for copilot-prompts Repository

## Overview

This repository contains curated GitHub Copilot chat modes, collections, instructions, prompts, agents, and skills
designed to enhance the Copilot development experience. It is a meta-repository focused on prompt engineering, agent
configurations, and reusable workflows for TypeScript development.

**Key Purpose**: Provide a structured collection of prompts, agents, and skills that can be used across different
projects to improve AI-assisted development workflows.

## Limitations

- **No Build Process**: This repository does not contain executable code or a traditional build process. It consists of
  markdown documentation and configuration files.
- **No Runtime Tests**: There are no unit or integration tests to run. Validation is done through linting and format
  checking.
- **No Package Dependencies**: No npm, pip, or other package managers are used. All dependencies are managed through
  pre-commit hooks.
- **Pre-commit Hooks Required**: The repository uses pre-commit hooks that may not be installed in the sandboxed
  environment. When pre-commit or ai-linter commands fail, document the issue and proceed with manual validation.

## Navigating the Codebase

### Directory Structure

```
.github/
├── agents/                      # Custom agent definitions
│   └── refactor-class.prompt.md # Agent for clean code refactoring
├── commit-message.instructions.md # Commit message guidelines (generated)
├── prompts/                     # Reusable prompt templates
│   ├── boost-prompt.prompt.md   # Interactive prompt refinement
│   ├── smart.prompt.md          # Smart prompt improvement
│   ├── gpt-generate-commit-msg.prompt.md (generated)
│   └── *.prompt.template.md     # Source templates
├── scripts/                     # Utility scripts
│   └── sync-templates.sh        # Syncs templates to generated files
├── settings.json                # VSCode Copilot settings
├── skills/                      # Reusable skills for agents
│   ├── commit-message/          # Commit message generation skill
│   ├── copy-clipboard/          # Clipboard interaction skill
│   └── human-interaction/       # Interactive requirement gathering
└── snippets/                    # Code snippets and examples

collections/                     # Copilot collections definitions
└── fchastanet-copilot.collection.yml

.ai-linter-config.yaml          # AI linter configuration
.pre-commit-config.yaml         # Pre-commit hooks configuration
.markdownlint.jsonc             # Markdown linting rules
```

### File Types and Conventions

- **`.prompt.md`**: Prompt templates for Copilot agents/modes
- **`.instructions.md`**: Instructions for Copilot features
- **`SKILL.md`**: Skill definitions with YAML frontmatter
- **`AGENTS.md`**: Agent documentation (optional, advised by ai-linter)
- **`.template.md`**: Source files that are processed into generated files

### Key Files

- **`.github/skills/commit-message/SKILL.md`**: The canonical source for commit message guidelines
- **`.github/commit-message.instructions.md`**: Generated from the skill (via sync-templates.sh)
- **`.github/scripts/sync-templates.sh`**: Synchronizes template files with their generated versions
- **`.ai-linter-config.yaml`**: Configuration for validating prompts, agents, and skills

## Build & Commands

### No Traditional Build

This repository does not have a traditional build process (no compilation, bundling, etc.). All files are markdown
documentation and configuration.

### Available Commands

#### Linting and Validation

```bash
# Run pre-commit hooks on all files (requires pre-commit to be installed)
pre-commit run --all-files

# Run AI linter to validate skills, prompts, and agents (requires ai-linter)
ai-linter --skills . --log-format logfmt

# Run markdownlint
markdownlint '**/*.md' --disable=MD041

# Format markdown files
mdformat --wrap 120 --number .
```

#### Template Synchronization

```bash
# Sync template files to generated files
.github/scripts/sync-templates.sh
```

**Important**: Run this script after modifying:

- `.github/skills/commit-message/SKILL.md`
- `.github/skills/commit-message/references/example-commit-msg.md`
- `.github/prompts/*.prompt.template.md`

### VSCode Tasks

A task is configured in `.vscode/tasks.json`:
- **AI Linter: Validate Skills**: Runs ai-linter with skill validation

### Errors and Workarounds

#### Pre-commit Not Installed

**Error**: `bash: pre-commit: command not found`

**Workaround**: Pre-commit hooks are not available in the sandboxed environment. Skip pre-commit validation and manually
verify changes using:
1. Check markdown syntax visually
2. Ensure files follow the patterns in `.markdownlint.jsonc`
3. Verify YAML frontmatter is valid

#### AI Linter Not Installed

**Error**: `bash: ai-linter: command not found`

**Workaround**: AI linter is not available in the sandboxed environment. Manually validate:
1. Check that prompts/agents don't exceed token limits (5000 tokens, 500 lines)
2. Verify YAML frontmatter in SKILL.md files has required fields: `name`, `description`
3. Ensure referenced files exist (e.g., files in `references/` directories)
4. Check code snippets don't exceed 3 lines (per `.ai-linter-config.yaml`)

## Code Style

### Markdown Style

Follow the rules in `.markdownlint.jsonc`:
- **Line length**: 120 characters max
- **Indentation**: 2 spaces for lists
- **Heading style**: Consistent (use existing style)
- **Line endings**: LF (Unix-style)
- **Trailing whitespace**: Not allowed

### YAML Frontmatter

All skills and prompts use YAML frontmatter enclosed in `---`:

**Skills** (SKILL.md files):
```yaml
---
name: skill-name
description: "Brief description"
---
```

**Prompts/Agents** (.prompt.md files):
```yaml
---
mode: agent|ask
description: "Brief description"
tools: [optional, list, of, tools]  # For agents
model: chatgpt-4                     # Optional
---
```

### File Naming Conventions

- Skills: `SKILL.md` (uppercase)
- Prompts: `*.prompt.md`
- Templates: `*.prompt.template.md`
- Instructions: `*.instructions.md`
- References: Keep in `references/` subdirectories

### Content Guidelines

- **Token Limits**: Prompts and agents should not exceed 5000 tokens or 500 lines
- **Code Snippets**: Keep inline code snippets to 3 lines or less; externalize larger code to `references/`
- **Markdown Links**: Use relative paths for internal references
- **Emojis**: Use emojis in commit messages and agent descriptions for clarity

## Testing

### No Automated Tests

This repository has no traditional test suite. Validation is performed through:

1. **Linting**: Markdown and YAML validation via pre-commit hooks
2. **AI Linter**: Validates prompts, agents, and skills structure
3. **Manual Review**: Ensure prompts and agents work as intended in Copilot

### Manual Validation Steps

When adding or modifying files:

1. **For Skills**: 
   - Verify YAML frontmatter is valid
   - Check that referenced files exist
   - Ensure description is clear and concise
   - Run sync-templates.sh if modifying commit-message skill

2. **For Prompts/Agents**:
   - Verify YAML frontmatter is valid
   - Test in GitHub Copilot if possible
   - Check token count doesn't exceed limits
   - Ensure description accurately reflects functionality

3. **For Documentation**:
   - Verify markdown syntax
   - Check all links resolve correctly
   - Ensure line length doesn't exceed 120 characters

## Security

### Sensitive Information

- **No Secrets**: This repository contains no secrets or sensitive data
- **Public Repository**: All content is intended to be public
- **No Code Execution**: Files are documentation only; no executable code

### Pre-commit Hooks

Security checks in `.pre-commit-config.yaml`:
- `detect-private-key`: Prevents committing private keys
- `check-merge-conflict`: Detects merge conflict markers
- `check-executables-have-shebangs`: Ensures shell scripts have proper headers

## Configuration

### AI Linter Configuration (`.ai-linter-config.yaml`)

Key settings:
- **Max warnings**: 10 before failure
- **Prompt max tokens**: 5000
- **Prompt max lines**: 500
- **Agent max tokens**: 5000
- **Agent max lines**: 500
- **Code snippet max lines**: 3

### Pre-commit Configuration (`.pre-commit-config.yaml`)

Hooks configured:
- **mdformat**: Formats markdown with 120-char line wrapping
- **markdownlint**: Lints markdown files
- **ai-linter-workspace**: Validates skills, prompts, and agents
- **sync-templates**: Synchronizes template files

**Important Exclusions**:
- `.github/prompts/` files excluded from some formatting
- `.github/commit-message.instructions.md` excluded (it's generated)
- `AGENTS.md` and `SKILL.md` files excluded from auto-formatting

### VSCode Settings (`.github/settings.json`)

Configures Copilot to use commit message skill:
```json
{
  "github.copilot.chat.commitMessageGeneration.instructions": [
    {
      "file": ".github/skills/commit-message/SKILL.md"
    }
  ]
}
```

## Architecture

### Template System

The repository uses a template synchronization system:

1. **Source**: `.github/skills/commit-message/SKILL.md` (with frontmatter)
2. **Generated**: `.github/commit-message.instructions.md` (without frontmatter)
3. **Script**: `.github/scripts/sync-templates.sh` handles synchronization

The script:
- Strips YAML frontmatter from skills
- Embeds referenced files inline (e.g., example-commit-msg.md)
- Generates both instructions and prompt files

### Skills System

Skills are reusable components that can be referenced by agents and prompts:

- **Location**: `.github/skills/{skill-name}/SKILL.md`
- **Structure**: YAML frontmatter + markdown content
- **References**: Can include external files from `references/` subdirectory

### Collections System

Collections group related items for discovery:

- **Location**: `collections/*.collection.yml`
- **Purpose**: Define groups of prompts, agents, skills for GitHub Copilot
- **Format**: YAML with metadata and item paths

## Git Commit Conventions

This repository follows detailed commit message conventions defined in `.github/skills/commit-message/SKILL.md`.

### Commit Message Format

```markdown
🎨(scope): Brief description (50-72 chars)

1-2 sentence summary of changes (100-200 chars).

## 1. 🎨 Section Header

- Detailed change 1
- Detailed change 2
```

### Key Principles

- Use emojis to categorize changes (✨ features, 🔧 refactoring, 🐛 bugs, etc.)
- Include scope in parentheses (e.g., `(config)`, `(skills)`, `(prompts)`)
- Use imperative mood ("Add feature" not "Added feature")
- Limit title to 50-72 characters
- Wrap body at 72-80 characters
- Group related changes under themed sections

### Common Scopes

- `config`: Configuration changes
- `skills`: Skill modifications
- `prompts`: Prompt changes
- `agents`: Agent updates
- `docs`: Documentation

## Troubleshooting

### Sync Script Fails

**Issue**: `.github/scripts/sync-templates.sh` fails

**Solutions**:
1. Check that source files exist:
   - `.github/skills/commit-message/SKILL.md`
   - `.github/skills/commit-message/references/example-commit-msg.md`
2. Ensure script has execute permissions: `chmod +x .github/scripts/sync-templates.sh`
3. Run manually: `bash .github/scripts/sync-templates.sh`

### Markdown Formatting Issues

**Issue**: Lines exceed 120 characters

**Solution**: 
- Break long lines at natural breakpoints
- Use markdown line continuation (backslash) if needed
- Tables are exempt from line length rules (per `.markdownlint.jsonc`)

### YAML Frontmatter Errors

**Issue**: Invalid YAML in frontmatter

**Solution**:
- Ensure `---` markers are on their own lines
- Validate YAML syntax online or with a YAML linter
- Check for proper quoting of strings with special characters
- Verify all array items use consistent formatting

### Missing Referenced Files

**Issue**: AI linter reports unreferenced files

**Solution**:

- Ensure files in `references/` are linked from main content
- Use markdown image syntax as a special marker: `![Description](path/to/file.md)`
  - Note: This is a custom convention in this repo. The sync-templates.sh script replaces these markers with actual file
    content
- Check relative paths are correct
- Update `.ai-linter-config.yaml` if intentional

## Summary

This is a documentation-focused repository with no executable code. When working here:

1. **Focus on markdown quality** - Follow linting rules and style guidelines
2. **Maintain template system** - Run sync-templates.sh when needed
3. **Validate YAML frontmatter** - Ensure all skills/prompts have valid metadata
4. **Document workarounds** - If tools are unavailable, manually validate changes
5. **Test in Copilot** - When possible, verify prompts/agents work as intended
6. **Keep it minimal** - This is a curated collection; maintain high quality over quantity
