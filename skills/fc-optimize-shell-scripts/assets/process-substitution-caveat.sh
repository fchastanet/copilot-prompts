#!/usr/bin/env bash
# WRONG - grep failure won't stop script even with errexit
while IFS='' read -r line; do
  echo "${line}"
done < <(grep "pattern" nonexistent-file)

# CORRECT - Use pipe instead
grep "pattern" file.txt | while IFS='' read -r line; do
  echo "${line}"
done
