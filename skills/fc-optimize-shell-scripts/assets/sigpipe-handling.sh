#!/usr/bin/env bash
# This causes exit code 141 because grep -q exits immediately
cat large-file.txt | grep -q "pattern"

# Handle pipeline failures elegantly
handle_pipefail() {
  # ignore exit code 141 from simple command pipes
  (($1 == 141)) && return 0
  return $1
}

# Use it like this
yes | head -n 1 || handle_pipefail $?
