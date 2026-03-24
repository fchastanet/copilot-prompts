#!/usr/bin/env bash
declare -a cmd=(git push origin ":${branch}")
echo "${cmd[*]}"  # Display command
"${cmd[@]}"       # Execute command
