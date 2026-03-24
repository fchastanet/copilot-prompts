#!/usr/bin/env bash
# Extract directory from full file path
directory="${REAL_SCRIPT_FILE%/*}"

# Extract file name from full file path
fileName="${REAL_SCRIPT_FILE##*/}"
