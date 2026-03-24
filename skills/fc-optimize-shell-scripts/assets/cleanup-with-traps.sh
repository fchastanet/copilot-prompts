#!/usr/bin/env bash
cleanOnExit() {
  local rc=$?
  if [[ "${KEEP_TEMP_FILES:-0}" = "1" ]]; then
    echo "KEEP_TEMP_FILES=1 temp files kept here '${TMPDIR}'"
  elif [[ -n "${TMPDIR+xxx}" ]]; then
    echo "Removing temp files '${TMPDIR}'"
    rm -Rf "${TMPDIR:-/tmp/fake}" >/dev/null 2>&1
  fi
  exit "${rc}"  # Preserve original exit code
}
trap cleanOnExit EXIT HUP QUIT ABRT TERM
