#!/usr/bin/env bash
# Without pipefail, this succeeds even though 'foo' fails
foo | echo "a"  # exit code is 0

# With pipefail, the pipeline fails with foo's exit code
set -o pipefail
foo | echo "a"  # exit code is 127 (command not found)
