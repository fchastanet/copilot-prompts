#!/usr/bin/env bash
# Use || true to ignore expected failures
rm -Rf folder || true

# Commands in if statements won't stop the program
if git diff-index --quiet HEAD --; then
  echo "No changes detected"
else
  echo "Changes detected"
fi
