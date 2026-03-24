#!/usr/bin/env bash
codeToMeasureStart=$(date +%s%3N)
# ... code to measure
echo >&2 "printCurrentLine;$(($(date +%s%3N) - codeToMeasureStart))"
