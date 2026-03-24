#!/usr/bin/env bash
# WRONG - internal 'refs' conflicts with reference name
Postman::getValidRefs() {
  local -n getValidRefs=$1
  local -a refs=("$@")  # Collision!
  getValidRefs=("${refs[@]}")  # Assignment fails
}

# CORRECT - scope all internal variables
Postman::getValidRefs() {
  local -n getValidRefsResult=$1
  local -a getValidRefsSelection=("$@")
  getValidRefsResult=("${getValidRefsSelection[@]}")
}
