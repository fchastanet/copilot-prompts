#!/usr/bin/env bash
# Read file lines into array
readarray -t var < /path/to/filename

# Alternative for command output
readarray -t lines <<<"$(some_command)"
