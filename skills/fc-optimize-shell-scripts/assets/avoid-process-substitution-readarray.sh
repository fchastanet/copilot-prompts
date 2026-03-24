#!/usr/bin/env bash
# WRONG - Can't capture exit status
declare -a items
readarray -t items < <(command_that_might_fail)

# CORRECT - Capture in same subshell or use heredoc
readarray -t items <<<"$(command_that_might_fail)"

# ALTERNATIVE - Process in same subshell
command_that_produces_items | {
  declare -a items
  readarray -t items
  process_items "${items[@]}"
}
