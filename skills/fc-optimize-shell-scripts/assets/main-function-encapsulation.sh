#!/usr/bin/env bash

main() {
  set -euo pipefail

  # All script logic here
  echo "Script execution"
}

# Execute main only if called as script, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
