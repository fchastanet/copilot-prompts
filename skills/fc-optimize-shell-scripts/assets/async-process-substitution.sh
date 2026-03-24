#!/usr/bin/env bash
mapfile -t lines < <(
  echo 1
  sleep 1
  exit 77
)
wait $!  # Wait for background process and capture exit status

for line in "${lines[@]}"; do
  echo "$line"
done
