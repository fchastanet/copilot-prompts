#!/usr/bin/env bash
# ✅ CORRECT - Scoped naming
Array::setArray() {
  local -n setArray_array=$1  # Scoped name prevents collision
  local IFS=$2 -
  set -f
  setArray_array=($3)
}

Array::setArray arr , "1,2,3,"  # Works correctly
