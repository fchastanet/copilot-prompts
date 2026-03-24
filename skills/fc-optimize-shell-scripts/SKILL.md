---
name: fc-optimize-shell-scripts
description: Optimize shell scripts for better performance and maintainability in sh files or in RUN instructions in Dockerfiles or in sh instruction in Jenkinsfiles.
licence: MIT
---

# Shell Scripting Guidelines

Instructions for writing clean, safe, and maintainable shell scripts for bash, sh, zsh, and other shells.

## General Principles

- Generate code that is clean, simple, and concise
- Ensure scripts are easily readable and understandable
- Add comments where helpful for understanding how the script works
- Generate concise and simple echo outputs to provide execution status
- Avoid unnecessary echo output and excessive logging
- Use shellcheck for static analysis when available
- Assume scripts are for automation and testing rather than production systems unless specified otherwise
- Prefer safe expansions: double-quote variable references (`"$var"`), use `${var}` for clarity, and avoid `eval`
- Use modern Bash features (`[[ ]]`, `local`, arrays) when portability requirements allow; fall back to POSIX constructs only when needed
- Choose reliable parsers for structured data instead of ad-hoc text processing
- Use the right shebang: `#!/usr/bin/env bash` instead of `#!/bin/bash` (bash binary could be in another folder, especially on Alpine)
- Prefer `printf` over `echo` for better portability and consistent behavior
- Use `builtin cd` instead of `cd`, `builtin pwd` instead of `pwd` to avoid using customized aliased commands
- Use `cat << 'EOF'` (with quotes) to avoid variable interpolation in heredocs when not needed
- Avoid global variables whenever possible; prefer using `local` in functions
- Avoid using `export` whenever possible; export is needed only when variables must be passed to child processes

## Error Handling & Safety

### Core Safety Options

Always enable `set -euo pipefail` to fail fast on errors, catch unset variables, and surface pipeline failures:

- `set -e` or `set -o errexit` - Exit immediately when a command returns non-zero status
- `set -u` or `set -o nounset` - Treat unset variables as errors
- `set -o pipefail` - Return value of pipeline is the last non-zero exit status
- `set -E` or `set -o errtrace` - Inherit ERR traps in functions and subshells

### errexit (set -e | set -o errexit)

Exit immediately when a command returns a non-zero status. While useful, it has important caveats:

**When commands are expected to fail:**

**[Example: Handling Expected Failures](assets/errexit-expected-failures.sh)**

**Caveat with command substitution:**

**[Example: Command Substitution Caveat](assets/command-substitution-caveat.sh)**

**Caveat with process substitution:**

Process substitution launches commands in separate processes, making error detection difficult:

**[Example: Process Substitution Caveat](assets/process-substitution-caveat.sh)**

**Process substitution is asynchronous - Use wait to capture exit status:**

**[Example: Async Process Substitution](assets/async-process-substitution.sh)**

### pipefail (set -o pipefail)

Without `pipefail`, failure of commands in a pipeline can hide errors:

**[Example: Pipefail Behavior](assets/pipefail-example.sh)**

### errtrace (set -E | set -o errtrace)

Ensures ERR traps are inherited by functions, command substitutions, and subshells.

### nounset (set -u | set -o nounset)

Treats unset variables as errors. Use `${VAR:-default}` or `${VAR-default}` for optional variables.

### inherit_errexit (shopt -s inherit_errexit)

Available in Bash 4.4+. Makes command substitution inherit `set -e`:

**[Example: inherit_errexit Behavior](assets/inherit-errexit-example.sh)**

### Additional Safety Practices

- Validate all required parameters before execution
- Provide clear error messages with context
- Use `trap` to clean up temporary resources or handle unexpected exits
- Declare immutable values with `readonly` (or `declare -r`) to prevent accidental reassignment
- Use `mktemp` to create temporary files or directories safely and ensure they are removed in your cleanup handler

### Handling SIGPIPE - Exit Code 141

With `set -o pipefail`, commands like `grep -q` or `head` that exit early can cause exit code 141 (SIGPIPE):

**[Example: Handling SIGPIPE](assets/sigpipe-handling.sh)**

## Script Structure

### Main Function Encapsulation

**Always encapsulate all script logic inside a main function.** This provides several benefits:

- Prevents partial execution if the script is truncated during download or editing
- Ensures syntax is validated before any execution begins
- Allows the script to be safely sourced without executing

**[Example: Main Function Encapsulation](assets/main-function-encapsulation.sh)**

### Standard Structure

- Start with a clear shebang: `#!/usr/bin/env bash`
- Include a header comment explaining the script's purpose
- Define default values for all variables at the top
- Use functions for reusable code blocks
- Create reusable functions instead of repeating similar blocks of code
- Keep the main execution flow clean and readable

## Variables

### Variable Declaration

- Ensure no globals exist; all variables should be passed to functions
- Declare all variables as `local` in functions to avoid making them global
- Use `local` or `declare` for multiple variables: `local var1 var2 var3`
- For `export readonly`, first use `readonly` then `export` (cannot combine them)
- Avoid using `export` most of the time; only needed when variables must be passed to child processes

### Variable Naming Convention

- Environment variables that aim to be exported should be CAPITALIZED_WITH_UNDERSCORE
- Local variables should conform to camelCase

### Variable Expansion

See [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)

**Using default values:**

- `${PARAMETER:-WORD}` - Use WORD if PARAMETER is unset or empty
- `${PARAMETER-WORD}` - Use WORD only if PARAMETER is unset (not when empty)

⚠️ Use the latter syntax (`-` without colon) for function arguments to allow resetting a value to empty string.

**Extraction examples:**

**[Example: Variable Expansion for Path Extraction](assets/variable-expansion-examples.sh)**

### Checking if Variable is Defined

**[Example: Check if Variable is Defined](assets/check-variable-defined.sh)**

### Variable Default Values

**Always set default values** to prevent dangerous operations:

**[Example: Variable Default Values](assets/variable-default-values.sh)**

### Passing Variables by Reference

Always "scope" variables passed by reference to avoid name collisions:

**❌ WRONG - Circular reference:**

**[Example: Passing by Reference - Wrong](assets/passing-by-reference-wrong.sh)**

**✅ CORRECT - Scoped naming:**

**[Example: Passing by Reference - Correct](assets/passing-by-reference-correct.sh)**

**Tricky example - Internal variable collision:**

**[Example: Passing by Reference - Tricky Case](assets/passing-by-reference-tricky.sh)**

### Escaping Quotes

**[Example: Escaping Quotes](assets/escaping-quotes.sh)**

## Arguments

### Complex Command Construction

Use arrays for complex commands:

**[Example: Complex Command Construction](assets/complex-command-construction.sh)**

### Boolean Arguments

Instead of confusing calls like `myFunction 0 1 0`, use named constants:

**[Example: Boolean Arguments](assets/boolean-arguments.sh)**

### Environment Variable Overrides

Instead of adding arguments with default values, consider using environment variables:

**[Example: Environment Variable Override](assets/environment-variable-override.sh)**

## Arrays

### Reading Lines to Array

**[Example: Reading Lines to Array](assets/reading-lines-to-array.sh)**

### Avoid Process Substitution with readarray

**[Example: Avoid Process Substitution with readarray](assets/avoid-process-substitution-readarray.sh)**

## Capturing Command Output

### Basic Capture

Always assign to variable first (don't use in echo directly):

**[Example: Basic Capture](assets/basic-capture.sh)**

### Capture with Error Handling

**[Example: Capture with Error Handling](assets/capture-with-error-handling.sh)**

### Capture Output and Status Code

Keep on same line with `;` to ensure status code is from correct command:

**[Example: Capture Output and Status Code](assets/capture-output-and-status.sh)**

## Temporary Files and Cleanup

### Temporary Directory

Use `${TMPDIR:-/tmp}` since TMPDIR variable may not exist:

**[Example: Temporary Directory](assets/temporary-directory.sh)**

### Cleanup with Traps

Always preserve and return the original exit code:

**[Example: Cleanup with Traps](assets/cleanup-with-traps.sh)**

## Common Command Best Practices

### sed

Always use extended regex: `sed -E`

### grep

- Avoid `grep -P` (not supported on Alpine); use `-E` instead
- Use `LC_ALL=POSIX` to prevent matching accented characters in `[A-Za-z]`:

  **[Example: grep with POSIX locale](assets/grep-locale-example.sh)**

## Regular Expressions

Bash and grep regular expressions handle character classes differently based on locale:

- `[A-Za-z]` matches accented characters by default
- Set `LC_ALL=POSIX` to match only ASCII letters:

  **[Example: grep with POSIX locale](assets/grep-locale-example.sh)**

- Consider adding `export LC_ALL=POSIX` in script headers (can be overridden in subshells)

## Performance Optimization

### Performance Measurement

Generate CSV with millisecond measurements:

**[Example: Performance Measurement](assets/performance-measurement.sh)**

### Performance Tips

**Use built-in features over external commands:**

- Use `echo` instead of string concatenation in loops
- Use parameter expansion (`${var//pattern/replacement}`) instead of calling `sed` repeatedly
- Avoid loops for simple transformations; use built-in string operations

**Example optimization:**

- String substitution vs `sed`: 90% faster for simple replacements
- `echo` vs concatenation: Significantly faster for building output
- Remove unnecessary `echo -e` by using simpler `echo` when possible

## Working with JSON and YAML

- Prefer dedicated parsers (`jq` for JSON, `yq` for YAML—or `jq` on JSON converted via `yq`) over ad-hoc text processing with `grep`, `awk`, or shell string splitting
- When `jq`/`yq` are unavailable or not appropriate, choose the next most reliable parser available in your environment, and be explicit about how it should be used safely
- Validate that required fields exist and handle missing/invalid data paths explicitly (e.g., by checking `jq` exit status or using `// empty`)
- Quote jq/yq filters to prevent shell expansion and prefer `--raw-output` when you need plain strings
- Treat parser errors as fatal: combine with `set -euo pipefail` or test command success before using results
- Document parser dependencies at the top of the script and fail fast with a helpful message if `jq`/`yq` (or alternative tools) are required but not installed

**[Example: Complete Script Template](assets/complete-script-template.sh)**

## Validation command

Use `shellcheck` for static analysis when available. If not available, use docker koalaman/shellcheck:stable image.

## External References

- [Pure Bash Bible](https://github.com/dylanaraps/pure-bash-bible?tab=readme-ov-file) - Collection of pure bash alternatives to external commands
- [Pure sh (POSIX) Bible](https://github.com/dylanaraps/pure-sh-bible?tab=readme-ov-file) - POSIX-compliant shell scripting techniques
