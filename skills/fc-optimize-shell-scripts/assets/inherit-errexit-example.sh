#!/usr/bin/env bash
# Without inherit_errexit - script continues despite error
set -e
MY_VAR=$(
  echo -n Start
  INVALID_COMMAND  # Error ignored
  echo -n End
)
echo "MY_VAR is $MY_VAR"  # Outputs: MY_VAR is StartEnd

# With inherit_errexit - script stops on error
set -e
shopt -s inherit_errexit
MY_VAR=$(
  echo -n Start
  INVALID_COMMAND  # Script stops here
  echo -n End
)
