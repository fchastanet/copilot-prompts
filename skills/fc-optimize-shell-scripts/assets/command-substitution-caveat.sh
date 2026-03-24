#!/usr/bin/env bash
# WRONG - This will NOT fail even with set -e
echo $(exit 1)

# CORRECT - Always assign command substitution to variable
declare cmdOut
cmdOut=$(exit 1)  # Script stops here if command fails
echo "${cmdOut}"
