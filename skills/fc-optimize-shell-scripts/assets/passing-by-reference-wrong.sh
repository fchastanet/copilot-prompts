#!/usr/bin/env bash
# ❌ WRONG - Circular reference
Array::setArray() {
  local -n arr=$1  # Collision if caller uses 'arr'
  local IFS=$2 -
  set -f
  arr=($3)
}

Array::setArray arr , "1,2,3,"  # ERROR: circular name reference
